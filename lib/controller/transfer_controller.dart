import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/transfer_service.dart';
import '../services/card_service.dart';
import '../model/cards/res/get_all_cards_res.dart' as card_model;

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
  String? error;
  final NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');

  final TransferService transferService;
  final CardService cardService;

  List<card_model.Card> cards = [];
  card_model.Card? sourceCard;
  card_model.Card? destCard;

  TransferController({
    required this.transferService,
    required this.cardService,
  });

  // Fetch all cards and update selected cards
  Future<void> fetchCards() async {
    isCardLoading = true;
    error = null;
    notifyListeners();
    try {
      final res = await cardService.getAllCards();
      cards = res.data;
      if (cards.isEmpty) {
        error = 'No cards available. Please create cards first.';
        isCardLoading = false;
        notifyListeners();
        return;
      }
      _updateSelectedCards();
      await fetchExchangeRate();
      isCardLoading = false;
      error = null;
      notifyListeners();
    } catch (e) {
      isCardLoading = false;
      error = 'Failed to fetch cards: ${e.toString()}';
      notifyListeners();
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

  void setSourceCurrency(String value) {
    sourceCurrency = value;
    if (sourceCurrency == destCurrency) {
      // Find a different currency that the user has a card for
      final availableCurrencies = cards.map((c) => c.currency).toSet();
      final differentCurrency =
          availableCurrencies.where((c) => c != sourceCurrency).firstOrNull;

      if (differentCurrency != null) {
        destCurrency = differentCurrency;
      }
    }
    _updateSelectedCards();
    fetchExchangeRate();
    notifyListeners();
  }

  void setDestCurrency(String value) {
    destCurrency = value;
    if (destCurrency == sourceCurrency) {
      // Find a different currency that the user has a card for
      final availableCurrencies = cards.map((c) => c.currency).toSet();
      final differentCurrency =
          availableCurrencies.where((c) => c != destCurrency).firstOrNull;

      if (differentCurrency != null) {
        sourceCurrency = differentCurrency;
      }
    }
    _updateSelectedCards();
    fetchExchangeRate();
    notifyListeners();
  }

  void setSourceAmount(String value) {
    sourceAmount = value;
    fetchExchangeRate();
    notifyListeners();
  }

  void setDestAmount(String value) {
    destAmount = value;
    // For reverse conversion, swap source/dest
    fetchExchangeRate(reverse: true);
    notifyListeners();
  }

  Future<void> fetchExchangeRate({bool reverse = false}) async {
    if (sourceCurrency == destCurrency) {
      exchangeRate = 1.0;
      destAmount = sourceAmount;
      notifyListeners();
      return;
    }
    try {
      isLoading = true;
      notifyListeners();
      // Fetch rate for 1 unit
      final rateRes = await transferService.currencyService.convertCurrency(
        1.0,
        sourceCurrency,
        destCurrency,
      );
      exchangeRate = rateRes.data.exchangeRate;

      double amount = 0.0;
      if (!reverse) {
        amount = double.tryParse(sourceAmount.replaceAll(',', '')) ?? 0.0;
        if (amount > 0) {
          final convRes = await transferService.currencyService.convertCurrency(
            amount,
            sourceCurrency,
            destCurrency,
          );
          destAmount = numberFormat.format(convRes.data.convertedAmount);
        } else {
          destAmount = '';
        }
      } else {
        amount = double.tryParse(destAmount.replaceAll(',', '')) ?? 0.0;
        if (amount > 0) {
          final convRes = await transferService.currencyService.convertCurrency(
            amount,
            destCurrency,
            sourceCurrency,
          );
          sourceAmount = numberFormat.format(convRes.data.convertedAmount);
        } else {
          sourceAmount = '';
        }
      }

      isLoading = false;
      error = null;
      notifyListeners();
    } catch (e) {
      exchangeRate = 0.0;
      isLoading = false;
      error = e.toString();
      notifyListeners();
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
      notifyListeners();
      return false;
    }

    isLoading = true;
    error = null;
    isSuccess = false;
    notifyListeners();
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
      notifyListeners();
      return result;
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
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
    notifyListeners();
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
}
