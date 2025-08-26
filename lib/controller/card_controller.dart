import 'package:flutter/material.dart';
import 'package:manycards/controller/currency_controller.dart';
import 'package:manycards/model/cards/res/get_all_cards_res.dart' as card_model;
import 'package:manycards/services/card_service.dart';

enum CardCurrency { ngn, gbp, usd }

class CardController extends ChangeNotifier {
  final CurrencyController _currencyController;
  final CardService _cardService;
  CardCurrency _selectedCurrency = CardCurrency.ngn;
  List<card_model.Card> _cards = [];
  bool _isLoading = false;
  bool _isCardDetailsVisible = false;

  CardController(this._currencyController, this._cardService) {
    // Listen to currency controller changes to update balances
    _currencyController.addListener(_onCurrencyControllerChanged);
    debugPrint('CardController initialized with currency: $_selectedCurrency');
    // Load cards when controller is initialized
    loadCards();
  }

  // Getters
  CardCurrency get selectedCurrency => _selectedCurrency;
  bool get isLoading => _isLoading;
  List<card_model.Card> get cards => _cards;
  bool get isCardDetailsVisible => _isCardDetailsVisible;

  // Get the card for the currently selected currency
  card_model.Card? get selectedCard {
    if (_cards.isEmpty) {
      debugPrint('No cards available');
      return null;
    }

    try {
      return _cards.firstWhere((card) => card.currency == currencyCode);
    } catch (e) {
      debugPrint('No card found for currency: $currencyCode');
      // If no card found for selected currency, return the first available card
      return _cards.isNotEmpty ? _cards.first : null;
    }
  }

  // Get the balance for the currently selected card
  double get balance {
    final card = selectedCard;
    if (card == null) {
      debugPrint('No card available for balance');
      return 0.0;
    }

    debugPrint('Getting balance for card ${card.number}:');
    debugPrint('- Currency: ${card.currency}');
    debugPrint('- Balance: ${card.balance}');
    return card.balance.toDouble();
  }

  // Card specific getters
  Color get cardColor {
    switch (_selectedCurrency) {
      case CardCurrency.ngn:
        return const Color(0xFF479951); // Current dark color
      case CardCurrency.gbp:
        return const Color(0xFF1E3A8A); // Blue color for GBP
      case CardCurrency.usd:
        return const Color(0xFF991B1B); // Red color for USD
    }
  }

  String get currencySymbol {
    switch (_selectedCurrency) {
      case CardCurrency.ngn:
        return '₦';
      case CardCurrency.gbp:
        return '£';
      case CardCurrency.usd:
        return '\$';
    }
  }

  String get currencyCode {
    switch (_selectedCurrency) {
      case CardCurrency.ngn:
        return 'NGN';
      case CardCurrency.gbp:
        return 'GBP';
      case CardCurrency.usd:
        return 'USD';
    }
  }

  // Methods
  void changeCurrency(CardCurrency currency) {
    if (_selectedCurrency != currency) {
      debugPrint('Changing currency from $_selectedCurrency to $currency');
      _selectedCurrency = currency;
      notifyListeners();
    }
  }

  void toggleCardDetailsVisibility() {
    _isCardDetailsVisible = !_isCardDetailsVisible;
    notifyListeners();
  }

  Future<void> loadCards() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _cardService.getAllCards();
      if (response.success) {
        _cards = response.data;
        debugPrint('Loaded ${_cards.length} cards');
        for (var card in _cards) {
          debugPrint('Card ${card.number}:');
          debugPrint('- Currency: ${card.currency}');
          debugPrint('- Balance: ${card.balance}');
        }
      } else {
        debugPrint('Failed to load cards: ${response.message}');
        // If no cards found, generate initial cards
        if (response.message.contains('No cards found')) {
          debugPrint('Generating initial cards...');
          final initialCardsResponse =
              await _cardService.generateInitialCards();
          if (initialCardsResponse.success) {
            _cards = initialCardsResponse.data;
            debugPrint('Generated ${_cards.length} initial cards');
            for (var card in _cards) {
              debugPrint('Generated card ${card.number}:');
              debugPrint('- Currency: ${card.currency}');
              debugPrint('- Balance: ${card.balance}');
            }
          } else {
            debugPrint(
              'Failed to generate initial cards: ${initialCardsResponse.message}',
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading cards: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onCurrencyControllerChanged() {
    debugPrint('CurrencyController changed');
    notifyListeners();
  }

  @override
  void dispose() {
    _currencyController.removeListener(_onCurrencyControllerChanged);
    super.dispose();
  }
}
