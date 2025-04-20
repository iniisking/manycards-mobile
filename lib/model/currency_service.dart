import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String apiKey = '54ca4274b22a9d03e0995a72';
  static const String baseUrl = 'https://v6.exchangerate-api.com/v6/$apiKey';

  // Get the latest exchange rates with a specific base currency
  Future<Map<String, dynamic>> getLatestRates(String baseCurrency) async {
    final response = await http.get(Uri.parse('$baseUrl/latest/$baseCurrency'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  // Convert a specific amount from one currency to another
  Future<double> convertCurrency(
    double amount,
    String fromCurrency,
    String toCurrency,
  ) async {
    final rates = await getLatestRates(fromCurrency);

    // API response format varies by provider - adjust accordingly
    final conversionRates = rates['conversion_rates'];
    if (conversionRates != null && conversionRates[toCurrency] != null) {
      return amount * conversionRates[toCurrency];
    } else {
      throw Exception('Currency not found');
    }
  }
}
