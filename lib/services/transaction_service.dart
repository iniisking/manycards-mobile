import 'package:flutter/material.dart';
import 'package:manycards/config/api_endpoints.dart';
import 'package:manycards/model/transaction history/res/get_all_transactions_res.dart';
import 'package:manycards/services/base_api_service.dart';
import 'package:manycards/services/auth_service.dart';

class TransactionService extends BaseApiService {
  TransactionService({required super.client, required AuthService authService})
    : super(authService: authService);

  Future<GetAllTransactionsRes> getAllTransactions() async {
    try {
      debugPrint(
        'Making transaction request to: ${ApiEndpoints.getAllTransactions}',
      );
      final response = await get(
        ApiEndpoints.getAllTransactions,
        queryParameters: null,
        requiresAuth: true,
        // useAwsSignature: true, // Removed to use only Bearer token
      );
      return GetAllTransactionsRes.fromJson(response);
    } catch (e) {
      debugPrint('Transaction service error: $e');
      throw Exception('Error getting transactions: $e');
    }
  }

  void dispose() {
    client.close();
  }
}
