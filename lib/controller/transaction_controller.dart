import 'package:flutter/material.dart';
import 'package:manycards/model/transaction history/res/get_all_transactions_res.dart';
import 'package:manycards/services/transaction_service.dart';

class TransactionController extends ChangeNotifier {
  final TransactionService _transactionService;

  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCurrency = 'USD';
  int _limit = 5; // Default limit for recent transactions

  TransactionController(this._transactionService);

  // Getters
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCurrency => _selectedCurrency;

  // Get recent transactions (first 5)
  List<Transaction> get recentTransactions {
    return _transactions.take(_limit).toList();
  }

  // Get transactions filtered by currency
  List<Transaction> getTransactionsByCurrency(String currency) {
    return _transactions
        .where(
          (transaction) =>
              transaction.currency == currency ||
              transaction.sourceCurrency == currency ||
              transaction.destinationCurrency == currency,
        )
        .toList();
  }

  // Get transactions for a specific card
  List<Transaction> getTransactionsByCardId(String cardId) {
    return _transactions
        .where(
          (transaction) =>
              transaction.cardId == cardId ||
              transaction.sourceCardId == cardId ||
              transaction.destinationCardId == cardId,
        )
        .toList();
  }

  // Methods
  void setSelectedCurrency(String currency) {
    if (_selectedCurrency != currency) {
      _selectedCurrency = currency;
      notifyListeners();
    }
  }

  void setLimit(int limit) {
    if (_limit != limit) {
      _limit = limit;
      notifyListeners();
    }
  }

  Future<void> loadTransactions({
    String? currency,
    String? cardId,
    int? limit,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _transactionService.getAllTransactions();
      debugPrint('API response (raw): ${response.data.transactions}');
      debugPrint('Transaction count: ${response.data.transactions.length}');
      if (response.success && response.data.transactions.isNotEmpty) {
        _transactions = response.data.transactions;
        // Sort transactions by date (most recent first)
        _transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        _transactions = [];
      }
    } catch (e) {
      _transactions = [];
      _error = 'Error loading transactions: $e';
      debugPrint('Error in loadTransactions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshTransactions({
    String? currency,
    String? cardId,
    int? limit,
  }) async {
    await loadTransactions(currency: currency, cardId: cardId, limit: limit);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
