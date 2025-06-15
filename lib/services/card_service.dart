import '../config/api_endpoints.dart';
import '../model/cards/res/get_all_cards_res.dart';
import 'base_api_service.dart';
import 'auth_service.dart';

class CardService extends BaseApiService {
  CardService({required super.client, required AuthService authService})
    : super(authService: authService);

  Future<GetAllCardsRes> getAllCards() async {
    try {
      final response = await get(ApiEndpoints.getAllCards, requiresAuth: true);

      return GetAllCardsRes.fromJson(response);
    } catch (e) {
      throw Exception('Error getting all cards: $e');
    }
  }

  Future<GetAllCardsRes> generateCard(String currency) async {
    try {
      final response = await post(
        ApiEndpoints.generateCard,
        body: {'currency': currency},
        requiresAuth: true,
      );
      return GetAllCardsRes.fromJson(response);
    } catch (e) {
      throw Exception('Error generating card: $e');
    }
  }

  Future<GetAllCardsRes> generateInitialCards() async {
    try {
      // Generate cards for all supported currencies
      final currencies = ['NGN', 'USD', 'GBP'];
      print('Starting to generate initial cards for currencies: $currencies');

      List<String> failedCurrencies = [];

      for (final currency in currencies) {
        try {
          print('Generating card for currency: $currency');
          final response = await generateCard(currency);
          if (response.success) {
            print(
              'Successfully generated card for $currency: ${response.message}',
            );
          } else {
            print('Failed to generate card for $currency: ${response.message}');
            failedCurrencies.add(currency);
          }
        } catch (e) {
          print('Error generating card for $currency: $e');
          failedCurrencies.add(currency);
        }
      }

      // If any currencies failed, try them again
      if (failedCurrencies.isNotEmpty) {
        print('Retrying failed currencies: $failedCurrencies');
        for (final currency in failedCurrencies) {
          try {
            print('Retrying card generation for currency: $currency');
            final response = await generateCard(currency);
            if (response.success) {
              print(
                'Successfully generated card for $currency on retry: ${response.message}',
              );
            } else {
              print(
                'Failed to generate card for $currency on retry: ${response.message}',
              );
            }
          } catch (e) {
            print('Error generating card for $currency on retry: $e');
          }
        }
      }

      // Return the updated list of cards
      print('Fetching updated list of cards');
      final allCards = await getAllCards();
      print('Retrieved ${allCards.data.length} cards');
      for (var card in allCards.data) {
        print('Card: ${card.currency} - ${card.maskedNumber}');
      }

      // Check if all currencies have cards
      final generatedCurrencies =
          allCards.data.map((card) => card.currency).toSet();
      final missingCurrencies =
          currencies.where((c) => !generatedCurrencies.contains(c)).toList();

      if (missingCurrencies.isNotEmpty) {
        print('Warning: Missing cards for currencies: $missingCurrencies');
      }

      return allCards;
    } catch (e) {
      print('Error in generateInitialCards: $e');
      throw Exception('Error generating initial cards: $e');
    }
  }

  void dispose() {
    client.close();
  }
}
