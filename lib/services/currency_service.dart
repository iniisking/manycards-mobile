import '../config/api_endpoints.dart';
import '../model/currency/req/convert_currency_req.dart';
import '../model/currency/res/convert_currency_res.dart';
import '../model/currency/res/get_total_card_balance_res.dart';
import 'base_api_service.dart';
import 'auth_service.dart';

class CurrencyService extends BaseApiService {
  CurrencyService({required super.client, required AuthService authService})
    : super(authService: authService);

  Future<GetTotalBalanceRes> getTotalBalance() async {
    try {
      final response = await get(
        ApiEndpoints.getTotalBalance,
        requiresAuth: true,
      );

      return GetTotalBalanceRes.fromJson(response);
    } catch (e) {
      throw Exception('Error getting total balance: $e');
    }
  }

  Future<ConvertCurrencyRes> convertCurrency(
    double amount,
    String fromCurrency,
    String toCurrency,
  ) async {
    try {
      final request = ConvertCurrencyReq(
        amount: amount,
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
      );

      final response = await post(
        ApiEndpoints.convertCurrency,
        body: request.toJson(),
        requiresAuth: true,
      );

      return ConvertCurrencyRes.fromJson(response);
    } catch (e) {
      throw Exception('Error converting currency: $e');
    }
  }

  void dispose() {
    client.close();
  }
}
