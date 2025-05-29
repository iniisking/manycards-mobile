import 'package:flutter/material.dart';

enum CardCurrency { ngn, gbp, usd }

class CardController extends ChangeNotifier {
  CardCurrency _selectedCurrency = CardCurrency.ngn;
  double _balance = 500.0;
  List<Map<String, dynamic>> _transactions = [];

  // Getters
  CardCurrency get selectedCurrency => _selectedCurrency;
  double get balance => _balance;
  List<Map<String, dynamic>> get transactions => _transactions;

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
      _selectedCurrency = currency;
      // TODO: Fetch new balance and transactions for the selected currency
      _updateMockData();
      notifyListeners();
    }
  }

  // Mock data update - replace with actual API calls later
  void _updateMockData() {
    switch (_selectedCurrency) {
      case CardCurrency.ngn:
        _balance = 500.20;
        break;
      case CardCurrency.gbp:
        _balance = 500.0;
        break;
      case CardCurrency.usd:
        _balance = 100.0;
        break;
    }
    // Mock transactions would be updated here
    _transactions = [];
  }
}
