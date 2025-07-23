import 'package:flutter/material.dart';
import 'package:manycards/controller/card_controller.dart';
import 'package:manycards/model/subcards/req/create_subcard_req.dart';
import 'package:manycards/model/subcards/res/get_all_subcard_res.dart';
import 'package:manycards/services/subcard_service.dart';

class SubcardController extends ChangeNotifier {
  final SubcardService _subcardService;
  final CardController _cardController;
  
  List<Datum> _subcards = [];
  bool _isLoading = false;
  bool _isCreating = false;
  String? _errorMessage;

  SubcardController(this._subcardService, this._cardController);

  // Getters
  List<Datum> get subcards => _subcards;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  String? get errorMessage => _errorMessage;
  bool get hasSubcards => _subcards.isNotEmpty;

  // Get subcards for the currently selected currency
  List<Datum> get subcardsForCurrentCurrency {
    final currentCurrency = _cardController.currencyCode;
    return _subcards.where((subcard) => subcard.mainCardCurrency == currentCurrency).toList();
  }

  // Get the selected card's currency info
  String get selectedCurrencyCode => _cardController.currencyCode;
  String get selectedCurrencySymbol => _cardController.currencySymbol;
  Color get selectedCardColor => _cardController.cardColor;

  Future<void> loadSubcards() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _subcardService.getAllSubcards();
      if (!response.error) {
        _subcards = response.data;
        print('Loaded subcards:');
        for (var s in _subcards) {
          print('   [32m${s.name} | currency: ${s.mainCardCurrency} | mainCardId: ${s.mainCardId} [0m');
        }
      } else {
        _errorMessage = response.message;
        _subcards = [];
      }
    } catch (e) {
      _errorMessage = e.toString();
      _subcards = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createSubcard({
    required String name,
    required String color,
    required int spendingLimit,
    required int durationDays,
    required bool resume,
    String merchantName = '',
    String merchantId = '',
  }) async {
    _isCreating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = CreateSubcardReq(
        mainCardId: _cardController.selectedCard?.cardId ?? '',
        color: color,
        name: name,
        merchantName: merchantName,
        merchantId: merchantId,
        spendingLimit: spendingLimit,
        durationDays: durationDays,
        resume: resume,
      );

      final response = await _subcardService.createSubcard(request);
      
      if (!response.error) {
        // Add the new subcard to the list
        _subcards.add(Datum(
          createdAt: response.data.createdAt,
          cardType: response.data.cardType,
          status: response.data.status,
          merchantName: response.data.merchantName,
          currentSpend: response.data.currentSpend,
          mainCardId: response.data.parentCardId,
          gsi1Sk: '', // Will be set by the API
          name: response.data.name,
          spendingLimit: response.data.spendingLimit,
          updatedAt: DateTime.now(),
          gsi1Pk: '', // Will be set by the API
          allowedMerchants: response.data.allowedMerchants,
          startDate: DateTime.now(),
          isLocked: response.data.isLocked,
          expirationDate: response.data.expirationDate,
          mainCardCurrency: _cardController.currencyCode,
          durationDays: 30, // Default duration
          sk: '', // Will be set by the API
          merchantId: response.data.merchantId,
          isActive: true,
          pk: '', // Will be set by the API
          type: 'SUB_CARD',
        ));
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }


} 