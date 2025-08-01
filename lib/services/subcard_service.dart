import 'package:flutter/material.dart';
import 'package:manycards/config/api_endpoints.dart';
import 'package:manycards/model/subcards/req/create_subcard_req.dart';
import 'package:manycards/model/subcards/res/create_subcard_res.dart';
import 'package:manycards/model/subcards/res/get_all_subcard_res.dart';
import 'package:manycards/model/subcards/res/delete_subcard_res.dart';
import 'package:manycards/services/base_api_service.dart';

class SubcardService extends BaseApiService {
  SubcardService({required super.client, super.authService});

  Future<CreateSubcardRes> createSubcard(CreateSubcardReq request) async {
    try {
      debugPrint(
        'Creating subcard with request: ${createSubcardReqToJson(request)}',
      );
      final response = await post(
        ApiEndpoints.createSubcard,
        body: createSubcardReqToJson(request),
        requiresAuth: true,
      );

      debugPrint('Create subcard response: $response');
      return createSubcardResFromJson(response);
    } catch (e) {
      debugPrint('Error creating subcard: $e');
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

  Future<GetAllSubcardRes> getAllSubcards(String mainCardId) async {
    try {
      debugPrint('Fetching all subcards for mainCardId: $mainCardId');
      final response = await post(
        ApiEndpoints.getAllSubcards,
        body: {'main_card_id': mainCardId},
        requiresAuth: true,
      );
      debugPrint('Get all subcards response: $response');
      return getAllSubcardResFromJson(response);
    } catch (e) {
      debugPrint('Error fetching subcards: $e');
      return GetAllSubcardRes(
        error: true,
        success: false,
        message: e.toString(),
        data: [],
      );
    }
  }

  Future<DeleteSubcardRes> deleteSubcard(String subcardId) async {
    try {
      debugPrint('Deleting subcard with id: $subcardId');
      final response = await post(
        ApiEndpoints.deleteSubcard,
        body: {'sub_card_id': subcardId},
        requiresAuth: true,
      );
      debugPrint('Delete subcard response: $response');
      return DeleteSubcardRes.fromJson(response);
    } catch (e) {
      debugPrint('Error deleting subcard: $e');
      return DeleteSubcardRes(
        success: false,
        message: e.toString(),
        cardId: subcardId,
      );
    }
  }
}
