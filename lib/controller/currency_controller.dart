// ignore_for_file: curly_braces_in_flow_control_structures, unused_field

import 'package:flutter/material.dart';
import 'package:manycards/services/currency_service.dart';
import '../model/currency/res/get_total_card_balance_res.dart';
import '../controller/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:manycards/gen/assets.gen.dart';
import 'package:manycards/utils/number_formatter.dart';

class CurrencyController extends ChangeNotifier {
  // --- Visibility Control ---
  bool _isBalanceVisible = true;
  bool get isBalanceVisible => _isBalanceVisible;

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  // --- Dependencies & State ---
  final AuthController _authController;
  final http.Client _httpClient;
  CurrencyService? _service;

  // --- Available Currencies ---
  final List<Map<String, dynamic>> _availableCurrencies = [
    {
      'code': 'NGN',
      'name': 'Nigerian Naira',
      'symbol': '₦',
      'flag': Assets.images.nigerianFlag.image(height: 25, width: 25),
    },
    {
      'code': 'USD',
      'name': 'United States Dollar',
      'symbol': '\$',
      'flag': Assets.images.usFlag.image(height: 25, width: 25),
    },
    {
      'code': 'GBP',
      'name': 'Great British Pound',
      'symbol': '£',
      'flag': Assets.images.ukFlag.image(height: 25, width: 25),
    },
  ];

  // --- Selected Currency ---
  String _selectedCurrencyCode = 'NGN';
  String get selectedCurrencyCode => _selectedCurrencyCode;

  Map<String, dynamic> get selectedCurrency {
    return _availableCurrencies.firstWhere(
      (currency) => currency['code'] == _selectedCurrencyCode,
      orElse: () => _availableCurrencies.first,
    );
  }

  void setSelectedCurrency(String code) {
    if (_selectedCurrencyCode != code &&
        _availableCurrencies.any((currency) => currency['code'] == code)) {
      _selectedCurrencyCode = code;
      notifyListeners(); // Notify immediately for selected currency change
      _updateCurrencyBalances(); // Trigger balance update after selecting currency
    }
  }

  // --- Currency List Getter ---
  List<Map<String, dynamic>> get currencies => _availableCurrencies;

  // --- Loading States ---
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  // --- Total Balance ---
  double _totalBalance = 0.0;
  double get totalBalance => _totalBalance;

  // --- Currency Balances ---
  final Map<String, double> _currencyBalances = {};
  double getBalanceForCurrency(String code) => _currencyBalances[code] ?? 0.0;

  String getFormattedBalance(String code) {
    final currency = _availableCurrencies.firstWhere(
      (c) => c['code'] == code,
      orElse: () => _availableCurrencies.first,
    );
    final balance = _currencyBalances[code] ?? 0.0;
    return NumberFormatter.formatBalanceWithSymbol(
      balance,
      currency['symbol'] as String,
    );
  }

  // --- Card Balances ---
  List<CardBalance> _cardBalances = [];
  List<CardBalance> get cardBalances => _cardBalances;

  // Get balance for a specific card
  CardBalance? getCardBalance(String cardId) {
    try {
      return _cardBalances.firstWhere((card) => card.cardId == cardId);
    } catch (e) {
      return null;
    }
  }

  // Get formatted balance for a specific card
  String getFormattedCardBalance(String cardId) {
    final card = getCardBalance(cardId);
    if (card == null) return '₦0.00';

    final currency = _availableCurrencies.firstWhere(
      (c) => c['code'] == card.originalCurrency,
      orElse: () => _availableCurrencies.first,
    );
    return NumberFormatter.formatBalanceWithSymbol(
      card.originalBalance,
      currency['symbol'] as String,
    );
  }

  // --- Reset State ---
  void reset() {
    _totalBalance = 0.0;
    _currencyBalances.clear();
    _cardBalances.clear();
    _isLoading = false;
    _isRefreshing = false;
    notifyListeners();
    debugPrint('CurrencyController state reset');
  }

  // --- Constructor ---
  CurrencyController(this._authController, this._httpClient) {
    _initializeService(); // Initialize service first
    // Listen to auth state changes
    _authController.addListener(_onAuthStateChanged);
  }

  void _onAuthStateChanged() {
    if (!_authController.isLoggedIn) {
      reset();
    } else {
      initializeBalances();
    }
  }

  @override
  void dispose() {
    _authController.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  // --- Initialize Service ---
  Future<void> _initializeService() async {
    debugPrint('Attempting to initialize CurrencyService...');
    _service = CurrencyService(
      client: _httpClient,
      authService: _authController.authService,
    );
    debugPrint('CurrencyService initialized.');
    // Now initialize balances
    debugPrint('Calling initializeBalances...');
    initializeBalances();
  }

  // --- Initialization --- // Called on app startup
  Future<void> initializeBalances() async {
    if (_service == null || _isRefreshing) {
      if (_service == null)
        debugPrint('Service not initialized in initializeBalances.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final totalBalanceRes = await _service!.getTotalBalance();

      if (totalBalanceRes.success) {
        _totalBalance = totalBalanceRes.data.totalBalance;
        // Store card balances
        _cardBalances = totalBalanceRes.data.cardBalances;
        debugPrint('Card balances updated: ${_cardBalances.length} cards');
        // Set NGN balance directly from total balance
        _currencyBalances['NGN'] = _totalBalance;
        // Now update other currency balances based on the total balance
        await _updateCurrencyBalances();
      } else {
        debugPrint('Failed to fetch total balance: ${totalBalanceRes.message}');
      }
    } catch (e) {
      debugPrint('Error initializing balances: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Refresh Balances --- // Called by pull-to-refresh on Home Screen
  Future<void> refreshBalances() async {
    if (_isRefreshing) return;

    if (_service == null) {
      debugPrint('Service not initialized in refreshBalances.');
      _initializeService();
      _isRefreshing = false;
      notifyListeners();
      return;
    }

    _isRefreshing = true;
    notifyListeners();

    try {
      final totalBalanceRes = await _service!.getTotalBalance();

      if (totalBalanceRes.success) {
        _totalBalance = totalBalanceRes.data.totalBalance;
        // Update card balances
        _cardBalances = totalBalanceRes.data.cardBalances;
        debugPrint('Card balances updated: ${_cardBalances.length} cards');
        // Set NGN balance directly from total balance
        _currencyBalances['NGN'] = _totalBalance;
        // Now update other currency balances based on the total balance
        await _updateCurrencyBalances();
      } else {
        debugPrint(
          'Failed to refresh total balance: ${totalBalanceRes.message}',
        );
      }

      await Future.delayed(const Duration(milliseconds: 600));
    } catch (e) {
      debugPrint('Error refreshing balances: $e');
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  // --- Update Currency Balances by Converting Total Balance ---
  Future<void> _updateCurrencyBalances() async {
    if (_service == null) {
      debugPrint('CurrencyService not initialized, cannot update balances.');
      return;
    }

    try {
      // Convert total balance to other currencies (USD and GBP)
      for (var currency in _availableCurrencies) {
        final code = currency['code'] as String;
        if (code == 'NGN') continue; // Skip NGN as it's already set

        final convertRes = await _service!.convertCurrency(
          _totalBalance,
          'NGN',
          code,
        );

        if (convertRes.success) {
          _currencyBalances[code] = convertRes.data.convertedAmount;
          debugPrint(
            'Converted total balance to $code: ${convertRes.data.convertedAmount}',
          );
          notifyListeners();
        } else {
          debugPrint(
            'Failed to convert total balance to $code: ${convertRes.message}',
          );
        }
      }
    } catch (e) {
      debugPrint('Error converting and updating balances: $e');
    }
  }
}
