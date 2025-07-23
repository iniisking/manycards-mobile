import 'package:flutter/material.dart';
import 'package:manycards/model/transaction history/res/get_all_transactions_res.dart';
import 'package:manycards/model/transaction history/req/get_all_transactions_req.dart';
import 'package:manycards/services/transaction_service.dart';
import 'dart:math';

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
    return _transactions.where((transaction) => 
      transaction.currency == currency || 
      transaction.sourceCurrency == currency ||
      transaction.destinationCurrency == currency
    ).toList();
  }

  // Get transactions for a specific card
  List<Transaction> getTransactionsByCardId(String cardId) {
    return _transactions.where((transaction) => 
      transaction.cardId == cardId ||
      transaction.sourceCardId == cardId ||
      transaction.destinationCardId == cardId
    ).toList();
  }

  // Generate dummy transaction data
  List<Transaction> _generateDummyTransactions() {
    final random = Random();
    final now = DateTime.now();
    final transactions = <Transaction>[];

    // Sample transaction data with realistic descriptions and varied amounts
    final dummyData = [
      {
        'type': 'FUNDING',
        'amount': 450000,
        'currency': 'NGN',
        'daysAgo': 2,
        'description': 'Card Funding',
      },
      {
        'type': 'TRANSFER',
        'amountDebited': 100000,
        'amountCredited': 48.21,
        'sourceCurrency': 'NGN',
        'destinationCurrency': 'GBP',
        'exchangeRate': 0.0004821,
        'daysAgo': 1,
        'description': 'Transfer to GBP main card',
      },
      {
        'type': 'TRANSFER',
        'amountDebited': 500000,
        'amountCredited': 326.66,
        'sourceCurrency': 'NGN',
        'destinationCurrency': 'USD',
        'exchangeRate': 0.00065332,
        'daysAgo': 2,
        'description': 'Transfer to USD main card',
      },
      {
        'type': 'FUNDING',
        'amount': 750000,
        'currency': 'NGN',
        'daysAgo': 3,
        'description': 'Card Funding',
      },
      {
        'type': 'TRANSFER',
        'amountDebited': 50,
        'amountCredited': 76518.66,
        'sourceCurrency': 'USD',
        'destinationCurrency': 'NGN',
        'exchangeRate': 1530.3732,
        'daysAgo': 1,
        'description': 'Transfer to NGN main card',
      },
      {
        'type': 'TRANSFER',
        'amountDebited': 200000,
        'amountCredited': 130.69,
        'sourceCurrency': 'NGN',
        'destinationCurrency': 'USD',
        'exchangeRate': 0.00065344,
        'daysAgo': 1,
        'description': 'Transfer to USD main card',
      },
      {
        'type': 'FUNDING',
        'amount': 300000,
        'currency': 'USD',
        'daysAgo': 4,
        'description': 'Card Funding',
      },
      {
        'type': 'TRANSFER',
        'amountDebited': 25000,
        'amountCredited': 19.23,
        'sourceCurrency': 'GBP',
        'destinationCurrency': 'USD',
        'exchangeRate': 0.7692,
        'daysAgo': 2,
        'description': 'Transfer to USD main card',
      },
    ];

    for (int i = 0; i < dummyData.length; i++) {
      final data = dummyData[i];
      final createdAt = now.subtract(Duration(days: data['daysAgo'] as int));
      
      if (data['type'] == 'FUNDING') {
        transactions.add(Transaction(
          transactionId: 'TRANS-${random.nextInt(1000000)}-${random.nextInt(1000000)}',
          type: 'FUNDING',
          status: 'COMPLETED',
          amount: data['amount'] as int,
          currency: data['currency'] as String,
          createdAt: createdAt,
          cardId: 'CARD-ca4001dd',
          reference: 'card-CARD-ca4001dd-${random.nextInt(1000000000)}',
          metadata: Metadata(
            userId: 'f4a8f4f8-a061-70d0-d53d-378a8a8533cf',
            cardId: 'CARD-ca4001dd',
          ),
        ));
      } else if (data['type'] == 'TRANSFER') {
        transactions.add(Transaction(
          transactionId: 'TRANS-${random.nextInt(1000000)}-${random.nextInt(1000000)}',
          type: 'TRANSFER',
          status: 'COMPLETED',
          amountDebited: data['amountDebited'] as int,
          amountCredited: data['amountCredited'] as double,
          sourceCurrency: data['sourceCurrency'] as String,
          destinationCurrency: data['destinationCurrency'] as String,
          exchangeRate: data['exchangeRate'] as double,
          sourceCardId: 'CARD-ca4001dd',
          destinationCardId: 'CARD-${random.nextInt(1000000)}',
          createdAt: createdAt,
          reference: null,
          metadata: Metadata(),
        ));
      }
    }

    return transactions;
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
      final request = GetAllTransactionsReq(
        currency: currency ?? _selectedCurrency,
        cardId: cardId,
        limit: limit ?? _limit,
      );

      final response = await _transactionService.getAllTransactions(
        request: request,
      );
      
      if (response.success && response.data.transactions.isNotEmpty) {
        _transactions = response.data.transactions;
        // Sort transactions by date (most recent first)
        _transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        // Use dummy data when API returns empty or fails
        _transactions = _generateDummyTransactions();
        // Sort transactions by date (most recent first)
        _transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
    } catch (e) {
      // Use dummy data when API throws an error
      _transactions = _generateDummyTransactions();
      // Sort transactions by date (most recent first)
      _transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
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
    await loadTransactions(
      currency: currency,
      cardId: cardId,
      limit: limit,
    );
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
} 