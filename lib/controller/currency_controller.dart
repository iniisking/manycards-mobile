// ignore_for_file: curly_braces_in_flow_control_structures, unused_field

import 'package:flutter/material.dart';
import 'package:manycards/services/currency_service.dart';
import '../model/currency_model.dart';
import '../controller/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

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
  final List<CurrencyModel> _currencies =
      CurrencyModel.getAvailableCurrencies();

  // --- Selected Currency ---
  String _selectedCurrencyCode = 'NGN';
  String get selectedCurrencyCode => _selectedCurrencyCode;

  CurrencyModel get selectedCurrency {
    return _currencies.firstWhere(
      (currency) => currency.code == _selectedCurrencyCode,
      orElse: () => _currencies.first,
    );
  }

  void setSelectedCurrency(String code) {
    if (_selectedCurrencyCode != code &&
        _currencies.any((currency) => currency.code == code)) {
      _selectedCurrencyCode = code;
      notifyListeners(); // Notify immediately for selected currency change
      _updateCurrencyBalances(); // Trigger balance update after selecting currency
    }
  }

  // --- Currency List Getter ---
  List<CurrencyModel> get currencies => _currencies;

  // --- Loading States ---
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  // --- Total Balance ---
  double _totalBalance = 0.0;
  double get totalBalance => _totalBalance;

  // --- Constructor ---
  CurrencyController(this._authController, this._httpClient) {
    _initializeService(); // Initialize service first
  }

  // --- Initialize Service ---
  Future<void> _initializeService() async {
    debugPrint('Attempting to initialize CurrencyService...');
    _service = CurrencyService(client: _httpClient);
    debugPrint('CurrencyService initialized.');
    // Now initialize balances
    debugPrint('Calling initializeBalances...');
    initializeBalances();
  }

  // --- Initialization --- // Called on app startup
  Future<void> initializeBalances() async {
    // Only proceed if service is initialized and not already refreshing
    if (_service == null || _isRefreshing) {
      if (_service == null)
        debugPrint('Service not initialized in initializeBalances.');
      // We are already in an initializing state (_isLoading is true by default),
      // so we just return if the service isn't ready or if refreshing.
      return;
    }

    _isLoading = true; // Set loading state
    notifyListeners();

    try {
      // Get total balance from backend
      debugPrint(
        'Fetching total balance in initializeBalances...',
      ); // Add this debug print
      final totalBalanceRes = await _service!.getTotalBalance();

      if (totalBalanceRes.success) {
        _totalBalance = totalBalanceRes.data.totalBalance.toDouble();
        // Now update all currency balances based on the total balance
        await _updateCurrencyBalances();
      } else {
        debugPrint('Failed to fetch total balance: ${totalBalanceRes.message}');
        // Optionally set a default or show an error message
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

    // Only proceed if service is initialized
    if (_service == null) {
      debugPrint('Service not initialized in refreshBalances.');
      // Attempt to re-initialize service if needed, but don't block refresh
      _initializeService();
      _isRefreshing = false;
      notifyListeners();
      return;
    }

    _isRefreshing = true;
    notifyListeners();

    try {
      // Get total balance from backend
      final totalBalanceRes = await _service!.getTotalBalance();

      if (totalBalanceRes.success) {
        _totalBalance = totalBalanceRes.data.totalBalance.toDouble();
        // Now update all currency balances based on the total balance
        await _updateCurrencyBalances();
      } else {
        debugPrint(
          'Failed to refresh total balance: ${totalBalanceRes.message}',
        );
        // Optionally show an error message
      }

      // delay so shimmer effect is noticeable
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
    // Ensure service is initialized and we have a total balance
    if (_service == null) {
      debugPrint('CurrencyService not initialized, cannot update balances.');
      return;
    }

    // Total balance can be zero, we can still convert zero.
    // if (_totalBalance <= 0) {
    //   debugPrint('Total balance is zero or negative, cannot convert.');
    //   return;
    // }

    try {
      // Iterate through all available currencies
      for (var currency in _currencies) {
        // Convert the total balance to the current currency's code
        // Use the total balance fetched from the backend, and NGN as the base
        final convertRes = await _service!.convertCurrency(
          _totalBalance, // Use total balance
          'NGN', // Assuming NGN is the base currency for conversion
          currency.code,
        );

        if (convertRes.success) {
          // Update the currency model's balance with the converted amount
          currency.balance = convertRes.data.convertedAmount;
          // Format the balance to include the symbol and correct decimal places
          currency.formatBalance();
          debugPrint(
            'Converted total balance to ${currency.code}: ${currency.formattedBalance}',
          );
          // Notify after each currency is updated to incrementally update UI
          notifyListeners();
        } else {
          debugPrint(
            'Failed to convert total balance to ${currency.code}: ${convertRes.message}',
          );
          // Optionally handle conversion failure for a specific currency
        }
      }
    } catch (e) {
      debugPrint('Error converting and updating balances: $e');
      // Optionally handle the overall error
    }
    // No need for final notifyListeners here as we notify in the loop
  }
}
