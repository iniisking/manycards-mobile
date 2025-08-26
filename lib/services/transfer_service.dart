import 'package:manycards/services/currency_service.dart';
import 'package:manycards/services/card_service.dart';
import 'package:manycards/model/cards/req/transfer_funds_req.dart';

class TransferService {
  final CurrencyService currencyService;
  final CardService cardService;

  TransferService({required this.currencyService, required this.cardService});

  Future<double> getExchangeRate(String from, String to) async {
    final res = await currencyService.convertCurrency(1.0, from, to);
    return res.data.exchangeRate;
  }

  Future<bool> transfer({
    required String sourceCardId,
    required String destinationCardId,
    required String sourceCurrency,
    required String destCurrency,
    required double sourceAmount,
  }) async {
    final req = TransferFundsReq(
      sourceCardId: sourceCardId,
      destinationCardId: destinationCardId,
      amount: sourceAmount,
      sourceCurrency: sourceCurrency,
      destinationCurrency: destCurrency,
    );
    final res = await cardService.transferFunds(req);
    return res.success;
  }
}
