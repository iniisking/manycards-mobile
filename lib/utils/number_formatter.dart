import 'package:intl/intl.dart';

class NumberFormatter {
  static String formatBalance(double balance, {int decimalPlaces = 2}) {
    // Create a number format with commas and specified decimal places
    final formatter = NumberFormat.currency(
      symbol: '', // We'll handle the currency symbol separately
      decimalDigits: decimalPlaces,
      locale: 'en_US', // Use US locale for comma formatting
    );

    // Format the number and remove any leading/trailing whitespace
    return formatter.format(balance).trim();
  }

  static String formatBalanceWithSymbol(
    double balance,
    String symbol, {
    int decimalPlaces = 2,
  }) {
    final formattedNumber = formatBalance(
      balance,
      decimalPlaces: decimalPlaces,
    );
    return '$symbol$formattedNumber';
  }
}
