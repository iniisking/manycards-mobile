import 'package:flutter/material.dart';
import 'package:manycards/services/currency_service.dart';
import '../model/currency_model.dart';

class CurrencyController extends ChangeNotifier {
  // --- Visibility Control ---
  bool _isBalanceVisible = true;
  bool get isBalanceVisible => _isBalanceVisible;

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  // --- Dependencies & State ---
  final CurrencyService _service = CurrencyService();
  final List<CurrencyModel> _currencies =
      CurrencyModel.getAvailableCurrencies();
  final double _baseBalanceUSD = 20198.00;

  // --- Selected Currency ---
  String _selectedCurrencyCode = 'USD';
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
      notifyListeners();
    }
  }

  // --- Currency List Getter ---
  List<CurrencyModel> get currencies => _currencies;

  // --- Loading States ---
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  // --- Constructor ---
  CurrencyController() {
    initializeBalances();
  }

  // --- Initialization ---
  Future<void> initializeBalances() async {
    _isLoading = true;
    notifyListeners();

    // Set base balance in USD
    CurrencyModel usdModel = _currencies.firstWhere((c) => c.code == 'USD');
    usdModel.balance = _baseBalanceUSD;
    usdModel.formatBalance();

    await refreshBalances();

    _isLoading = false;
    notifyListeners();
  }

  // --- Refresh Balances ---
  Future<void> refreshBalances() async {
    if (_isRefreshing) return;

    _isRefreshing = true;
    notifyListeners();

    try {
      final currenciesToUpdate = List<CurrencyModel>.from(_currencies);

      for (var currency in currenciesToUpdate) {
        if (currency.code != 'USD') {
          final newBalance = await _service.convertCurrency(
            _baseBalanceUSD,
            'USD',
            currency.code,
          );

          final index = _currencies.indexWhere((c) => c.code == currency.code);
          if (index != -1) {
            _currencies[index].balance = newBalance;
            _currencies[index].formatBalance();
          }
        }
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
}
