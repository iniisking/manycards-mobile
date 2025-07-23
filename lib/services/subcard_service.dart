import 'package:manycards/config/api_endpoints.dart';
import 'package:manycards/model/subcards/req/create_subcard_req.dart';
import 'package:manycards/model/subcards/res/create_subcard_res.dart';
import 'package:manycards/model/subcards/res/get_all_subcard_res.dart';
import 'package:manycards/services/base_api_service.dart';

class SubcardService extends BaseApiService {
  SubcardService({required super.client, super.authService});

  Future<CreateSubcardRes> createSubcard(CreateSubcardReq request) async {
    try {
      print('Creating subcard with request: ${createSubcardReqToJson(request)}');
      final response = await post(
        ApiEndpoints.createSubcard,
        body: createSubcardReqToJson(request),
        requiresAuth: true,
      );

      print('Create subcard response: $response');
      return createSubcardResFromJson(response);
    } catch (e) {
      print('Error creating subcard: $e');
      return CreateSubcardRes(
        error: true,
        message: e.toString(),
        data: Data(
          subCardId: '',
          name: '',
          cardType: '',
          isLocked: false,
          merchantId: '',
          merchantName: '',
          allowedMerchants: [],
          spendingLimit: 0,
          currentSpend: 0,
          status: false,
          parentCardId: '',
          currency: '',
          createdAt: DateTime.now(),
          expirationDate: DateTime.now(),
        ),
      );
    }
  }

  Future<GetAllSubcardRes> getAllSubcards() async {
    try {
      print('Fetching all subcards...');
      final response = await get(
        ApiEndpoints.getAllSubcards,
        requiresAuth: true,
      );
      print('Get all subcards response: $response');
      return getAllSubcardResFromJson(response);
    } catch (e) {
      print('Error fetching subcards: $e');
      return GetAllSubcardRes(
        error: true,
        success: false,
        message: e.toString(),
        data: [],
      );
    }
  }
} 