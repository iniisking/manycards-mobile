import 'package:manycards/config/api_endpoints.dart';
import 'package:manycards/model/transaction history/req/get_all_transactions_req.dart';
import 'package:manycards/model/transaction history/res/get_all_transactions_res.dart';
import 'package:manycards/services/base_api_service.dart';
import 'package:manycards/services/auth_service.dart';

class TransactionService extends BaseApiService {
  TransactionService({required super.client, required AuthService authService})
    : super(authService: authService);

  Future<GetAllTransactionsRes> getAllTransactions({
    GetAllTransactionsReq? request,
  }) async {
    try {
      Map<String, dynamic>? queryParameters;
      
      if (request != null) {
        queryParameters = request.toJson();
        print('Transaction request parameters: $queryParameters');
      }

      print('Making transaction request to: ${ApiEndpoints.getAllTransactions}');
      print('Query parameters: $queryParameters');

      final response = await get(
        ApiEndpoints.getAllTransactions,
        queryParameters: queryParameters,
        requiresAuth: true,
        useAwsSignature: true, // Required for this endpoint
      );

      return GetAllTransactionsRes.fromJson(response);
    } catch (e) {
      print('Transaction service error: $e');
      throw Exception('Error getting transactions: $e');
    }
  }

  void dispose() {
    client.close();
  }
} 