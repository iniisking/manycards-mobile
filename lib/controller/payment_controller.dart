import 'package:flutter/material.dart';
import 'package:manycards/model/payment/req/fund_account_req.dart';
import 'package:manycards/model/payment/req/paystack_webhook_req.dart';
import 'package:manycards/services/payment_service.dart';
import 'package:manycards/services/auth_service.dart';

class PaymentController extends ChangeNotifier {
  final PaymentService _paymentService;
  final AuthService _authService;
  String? authorizationUrl;
  String? reference;
  String? cardId;
  String? error;
  bool isLoading = false;
  double? _amount;

  PaymentController({
    required PaymentService paymentService,
    required AuthService authService,
  }) : _paymentService = paymentService,
       _authService = authService;

  Future<bool> initiateTopUp(BuildContext context, double amount) async {
    try {
      isLoading = true;
      error = null;
      _amount = amount;
      notifyListeners();

      // Get the NGN card ID from the auth service
      cardId = _authService.ngnCardId;
      debugPrint('NGN card ID from auth service: $cardId');

      if (cardId == null) {
        debugPrint('No NGN card ID found in auth service');
        error =
            'No NGN card found. Please try logging out and logging back in.';
        return false;
      }

      debugPrint('Initiating top up with card ID: $cardId and amount: $amount');
      final request = FundAccountReq(cardId: cardId!, amount: amount);

      final response = await _paymentService.fundAccount(request);
      debugPrint(
        'Fund account response: ${response.success} - ${response.message}',
      );

      authorizationUrl = response.authorizationUrl;
      reference = response.reference;
      return true;
    } catch (e) {
      debugPrint('Error in initiateTopUp: $e');
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyTransaction({
    required String reference,
    required String cardId,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      // Get the user ID from the auth service
      final userId = _authService.userId;
      if (userId == null) {
        error = 'User not authenticated';
        return false;
      }

      if (_amount == null) {
        error = 'Amount not found';
        return false;
      }

      // Create the webhook request
      final webhookReq = PaystackWebhookReq(
        event: 'charge.success',
        data: Data(
          reference: reference,
          amount: _amount!,
          currency: 'NGN',
          status: 'success',
          customer: Customer(
            email: _authService.email ?? '',
            phone: _authService.phone ?? '',
          ),
          metadata: Metadata(
            customFields: [
              CustomField(
                variableName: 'user_id',
                value: userId,
                displayName: 'User ID',
              ),
              CustomField(
                variableName: 'card_id',
                value: cardId,
                displayName: 'Card ID',
              ),
            ],
          ),
          paidAt: DateTime.now(),
        ),
      );

      final response = await _paymentService.verifyPaystackWebhook(webhookReq);
      return response.success;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
