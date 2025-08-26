import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/transfer_service.dart';
import '../services/card_service.dart';
import '../model/cards/res/get_all_cards_res.dart' as card_model;
import 'dart:async';

class TransferController extends ChangeNotifier {
  // State variables
  String sourceCurrency = 'USD';
  String destCurrency = 'NGN';
  String sourceAmount = '';
  String destAmount = '';
  double exchangeRate = 0.0;
  bool isLoading = false;
  bool isCardLoading = false;
  bool isSuccess = false;
  bool disposed = false;
  String? error;
  final NumberFormat numberFormat = NumberFormat('#,##0.##', 'en_US'); // Amount fields: up to 2 dp
  final NumberFormat rateFormat = NumberFormat('#,##0.00', 'en_US');   // Exchange rate: always 2 dp

  final TransferService transferService;
  final CardService cardService;

  List<card_model.Card> cards = [];
  card_model.Card? sourceCard;
  card_model.Card? destCard;

  TransferController({
    required this.transferService,
    required this.cardService,
  });

  void _safeNotifyListeners() {
    if (!disposed) {
      notifyListeners();
    }
  }

  // Fetch all cards and update selected cards
  Future<void> fetchCards() async {
    if (disposed) return;
    
    isCardLoading = true;
    error = null;
    _safeNotifyListeners();
    try {
      final res = await cardService.getAllCards();
      if (disposed) return;
      
      cards = res.data;
      if (cards.isEmpty) {
        error = 'No cards available. Please create cards first.';
        isCardLoading = false;
        _safeNotifyListeners();
        return;
      }
      // Only set sourceCurrency to the card with the highest balance if not already set
      final availableCurrencies = cards.map((c) => c.currency).toSet();
      if (!availableCurrencies.contains(sourceCurrency)) {
        final highest = cards.reduce((a, b) => a.balance > b.balance ? a : b);
        sourceCurrency = highest.currency;
      }
      // If destCurrency matches, pick a different one
      if (destCurrency == sourceCurrency || !availableCurrencies.contains(destCurrency)) {
        destCurrency = availableCurrencies.firstWhere((c) => c != sourceCurrency, orElse: () => sourceCurrency);
      }
      _updateSelectedCards();
      await fetchExchangeRate();
      if (disposed) return;
      
      isCardLoading = false;
      error = null;
      _safeNotifyListeners();
    } catch (e) {
      if (disposed) return;
      
      isCardLoading = false;
      error = 'Failed to fetch cards: ${e.toString()}';
      _safeNotifyListeners();
    }
  }

  void _updateSelectedCards() {
    try {
      // Find source card for the selected currency
      sourceCard = cards.firstWhere(
        (c) => c.currency == sourceCurrency,
        orElse: () {
          // If no card for source currency, use first available card
          if (cards.isNotEmpty) {
            final firstCard = cards.first;
            sourceCurrency = firstCard.currency;
            return firstCard;
          }
          throw Exception('No cards available');
        },
      );

      // Find destination card for the selected currency
      destCard = cards.firstWhere(
        (c) => c.currency == destCurrency,
        orElse: () {
          // If no card for dest currency, use first available card with different currency
          final availableCard = cards.firstWhere(
            (c) => c.currency != sourceCurrency,
            orElse:
                () =>
                    cards
                        .first, // Fallback to first card if only one currency available
          );
          destCurrency = availableCard.currency;
          return availableCard;
        },
      );
    } catch (e) {
      error = 'Error selecting cards: ${e.toString()}';
      sourceCard = null;
      destCard = null;
    }
  }

  // --- Robust dropdown state management ---
  List<String> get availableCurrencies => cards.map((c) => c.currency).toSet().where((c) => c.isNotEmpty).toList();

  List<String> get fromCurrencies => availableCurrencies.where((c) => c != destCurrency).toList();
  List<String> get toCurrencies => availableCurrencies.where((c) => c != sourceCurrency).toList();

  String? get validSourceCurrency => fromCurrencies.contains(sourceCurrency)
      ? sourceCurrency
      : (fromCurrencies.isNotEmpty ? fromCurrencies.first : null);
  String? get validDestCurrency => toCurrencies.contains(destCurrency)
      ? destCurrency
      : (toCurrencies.isNotEmpty ? toCurrencies.first : null);

  void setSourceCurrency(String value) {
    if (value == destCurrency) {
      // Swap
      final oldSource = sourceCurrency;
      sourceCurrency = destCurrency;
      destCurrency = oldSource;
    } else {
      sourceCurrency = value;
      // If destCurrency is now invalid, pick a valid one
      if (!toCurrencies.contains(destCurrency) && toCurrencies.isNotEmpty) {
        destCurrency = toCurrencies.first;
      }
    }
    _updateSelectedCards();
    fetchExchangeRate();
    _safeNotifyListeners();
  }

  void setDestCurrency(String value) {
    if (value == sourceCurrency) {
      // Swap
      final oldDest = destCurrency;
      destCurrency = sourceCurrency;
      sourceCurrency = oldDest;
    } else {
      destCurrency = value;
      // If sourceCurrency is now invalid, pick a valid one
      if (!fromCurrencies.contains(sourceCurrency) && fromCurrencies.isNotEmpty) {
        sourceCurrency = fromCurrencies.first;
      }
    }
    _updateSelectedCards();
    fetchExchangeRate();
    _safeNotifyListeners();
  }

  // Add editing state
  bool _editingSource = false;
  bool _editingDest = false;
  Timer? _debounce;
  String _lastSourceAmountRequested = '';
  String _lastDestAmountRequested = '';

  void setSourceAmount(String value) {
    _editingSource = true;
    _editingDest = false;
    sourceAmount = value;
    _lastSourceAmountRequested = value;
    debugPrint('[TransferController] setSourceAmount: $value');
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      fetchExchangeRate();
    });
    _safeNotifyListeners();
  }

  void setDestAmount(String value) {
    _editingSource = false;
    _editingDest = true;
    destAmount = value;
    _lastDestAmountRequested = value;
    debugPrint('[TransferController] setDestAmount: $value');
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      fetchExchangeRate(reverse: true);
    });
    _safeNotifyListeners();
  }

  Future<void> fetchExchangeRate({bool reverse = false}) async {
    debugPrint('[TransferController] fetchExchangeRate (reverse: $reverse)');
    if (sourceCurrency == destCurrency) {
      exchangeRate = 1.0;
      destAmount = sourceAmount;
      _editingSource = false;
      _editingDest = false;
      debugPrint('[TransferController] Same currency, destAmount set to $destAmount');
      _safeNotifyListeners();
      return;
    }
    try {
      isLoading = true;
      _safeNotifyListeners();
      // Fetch rate for 1 unit
      debugPrint('[TransferController] Calling convertCurrency(1.0, $sourceCurrency, $destCurrency)');
      final rateRes = await transferService.currencyService.convertCurrency(
        1.0,
        sourceCurrency,
        destCurrency,
      );
      debugPrint('[TransferController] Rate response: ${rateRes.data.exchangeRate}');
      exchangeRate = rateRes.data.exchangeRate;

      double amount = 0.0;
      if (!_editingDest) { // Only update destAmount if not editing dest
        amount = double.tryParse(sourceAmount.replaceAll(',', '')) ?? 0.0;
        final requested = _lastSourceAmountRequested;
        debugPrint('[TransferController] Converting $amount $sourceCurrency to $destCurrency');
        if (amount > 0) {
          final convRes = await transferService.currencyService.convertCurrency(
            amount,
            sourceCurrency,
            destCurrency,
          );
          debugPrint('[TransferController] Conversion response: ${convRes.data.convertedAmount}');
          // Only update if the input hasn't changed since request
          if (requested == sourceAmount) {
            destAmount = numberFormat.format(convRes.data.convertedAmount);
            debugPrint('[TransferController] destAmount updated: $destAmount');
          }
        } else {
          destAmount = '';
        }
      } else if (!_editingSource) { // Only update sourceAmount if not editing source
        amount = double.tryParse(destAmount.replaceAll(',', '')) ?? 0.0;
        final requested = _lastDestAmountRequested;
        debugPrint('[TransferController] Converting $amount $destCurrency to $sourceCurrency');
        if (amount > 0) {
          final convRes = await transferService.currencyService.convertCurrency(
            amount,
            destCurrency,
            sourceCurrency,
          );
          debugPrint('[TransferController] Reverse conversion response: ${convRes.data.convertedAmount}');
          // Only update if the input hasn't changed since request
          if (requested == destAmount) {
            sourceAmount = numberFormat.format(convRes.data.convertedAmount);
            debugPrint('[TransferController] sourceAmount updated: $sourceAmount');
          }
        } else {
          sourceAmount = '';
        }
      }

      isLoading = false;
      error = null;
      _editingSource = false;
      _editingDest = false;
      _safeNotifyListeners();
    } catch (e) {
      exchangeRate = 0.0;
      isLoading = false;
      error = e.toString();
      debugPrint('[TransferController] Error: $e');
      _editingSource = false;
      _editingDest = false;
      _safeNotifyListeners();
    }
  }

  // Validation for the source amount
  String? validateSourceAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter amount';
    }
    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      return 'Invalid amount';
    }
    if (sourceCurrency == 'NGN' && amount < 50) {
      return 'Minimum is ₦50';
    }
    if (sourceCurrency != 'NGN' &&
        exchangeRate > 0 &&
        (amount * exchangeRate) < 50) {
      return 'Minimum is ₦50 equivalent';
    }
    if (sourceCard != null && amount > sourceCard!.balance) {
      return 'Insufficient balance';
    }
    return null;
  }

  // Perform the transfer
  Future<bool> performTransfer() async {
    if (sourceCard == null || destCard == null) {
      error = 'Please select valid source and destination cards';
      _safeNotifyListeners();
      return false;
    }

    isLoading = true;
    error = null;
    isSuccess = false;
    _safeNotifyListeners();
    try {
      final reqAmount =
          double.tryParse(sourceAmount.replaceAll(',', '')) ?? 0.0;
      final result = await transferService.transfer(
        sourceCardId: sourceCard!.cardId,
        destinationCardId: destCard!.cardId,
        sourceCurrency: sourceCurrency,
        destCurrency: destCurrency,
        sourceAmount: reqAmount,
      );
      isLoading = false;
      isSuccess = result;
      _safeNotifyListeners();
      return result;
    } catch (e) {
      isLoading = false;
      error = e.toString();
      _safeNotifyListeners();
      return false;
    }
  }

  // Reset all state (for after a successful transfer)
  void reset() {
    sourceCurrency = 'USD';
    destCurrency = 'NGN';
    sourceAmount = '';
    destAmount = '';
    exchangeRate = 0.0;
    isLoading = false;
    isCardLoading = false;
    isSuccess = false;
    error = null;
    cards = [];
    sourceCard = null;
    destCard = null;
    _safeNotifyListeners();
  }

  // Computed property for form validity
  bool get isFormValid {
    return !isLoading &&
        !isCardLoading &&
        validateSourceAmount(sourceAmount) == null &&
        sourceAmount.isNotEmpty &&
        destAmount.isNotEmpty &&
        sourceCard != null &&
        destCard != null &&
        sourceCard!.cardId != destCard!.cardId; // Ensure different cards
  }

  @override
  void dispose() {
    disposed = true;
    _debounce?.cancel();
    super.dispose();
  }
}
