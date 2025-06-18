import 'package:manycards/config/api_endpoints.dart';
import 'package:manycards/model/payment/req/fund_account_req.dart';
import 'package:manycards/model/payment/res/fund_account_res.dart';
import 'package:manycards/model/payment/res/paystack_webhook_res.dart';
import 'package:manycards/model/payment/req/paystack_webhook_req.dart';
import 'package:manycards/services/base_api_service.dart';
import 'package:manycards/services/auth_service.dart';
import 'package:flutter/foundation.dart';

class PaymentService extends BaseApiService {
  PaymentService({required super.client, required AuthService authService})
    : super(authService: authService);

  Future<FundAccountRes> fundAccount(FundAccountReq request) async {
    try {
      debugPrint(
        'Initiating fund account request with amount: ${request.amount}',
      );
      final requestBody = request.toJson();
      debugPrint('Request body: $requestBody');

      final response = await post(
        ApiEndpoints.fundAccount,
        body: requestBody,
        requiresAuth: true,
      );

      debugPrint('Fund account response: $response');

      if (!response['success']) {
        throw Exception('Failed to fund account: ${response['message']}');
      }

      return FundAccountRes.fromJson(response);
    } catch (e) {
      debugPrint('Error in fundAccount: $e');
      rethrow;
    }
  }

  Future<PaystackWebhookRes> verifyPaystackWebhook(
    PaystackWebhookReq request,
  ) async {
    try {
      debugPrint(
        'Verifying Paystack webhook for reference: ${request.data.reference}',
      );
      final response = await post(
        ApiEndpoints.paystackWebhook,
        body: request.toJson(),
        requiresAuth: true,
      );

      debugPrint('Webhook verification response: $response');

      if (!response['success']) {
        throw Exception('Failed to verify webhook: ${response['message']}');
      }

      return PaystackWebhookRes.fromJson(response);
    } catch (e) {
      debugPrint('Error in verifyPaystackWebhook: $e');
      rethrow;
    }
  }
}
