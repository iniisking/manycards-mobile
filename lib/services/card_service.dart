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
      for (final currency in currencies) {
        await generateCard(currency);
      }
      // Return the updated list of cards
      return await getAllCards();
    } catch (e) {
      throw Exception('Error generating initial cards: $e');
    }
  }

  void dispose() {
    client.close();
  }
}
