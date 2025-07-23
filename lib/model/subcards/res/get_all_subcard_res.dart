class GetAllSubcardRes {
  final bool error;
  final bool success;
  final String message;
  final List<Datum> data;

  GetAllSubcardRes({
    required this.error,
    required this.success,
    required this.message,
    required this.data,
  });
}

class Datum {
  final DateTime createdAt;
  final String cardType;
  final bool status;
  final String merchantName;
  final int currentSpend;
  final String mainCardId;
  final String gsi1Sk;
  final String name;
  final int spendingLimit;
  final DateTime updatedAt;
  final String gsi1Pk;
  final List<String> allowedMerchants;
  final DateTime startDate;
  final bool isLocked;
  final DateTime expirationDate;
  final String mainCardCurrency;
  final int durationDays;
  final String sk;
  final String merchantId;
  final bool isActive;
  final String pk;
  final String type;

  Datum({
    required this.createdAt,
    required this.cardType,
    required this.status,
    required this.merchantName,
    required this.currentSpend,
    required this.mainCardId,
    required this.gsi1Sk,
    required this.name,
    required this.spendingLimit,
    required this.updatedAt,
    required this.gsi1Pk,
    required this.allowedMerchants,
    required this.startDate,
    required this.isLocked,
    required this.expirationDate,
    required this.mainCardCurrency,
    required this.durationDays,
    required this.sk,
    required this.merchantId,
    required this.isActive,
    required this.pk,
    required this.type,
  });
}

GetAllSubcardRes getAllSubcardResFromJson(Map<String, dynamic> json) {
  return GetAllSubcardRes(
    error: json['error'] ?? false,
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    data: List<Datum>.from(
      json['data'].map(
        (x) => Datum(
          createdAt: DateTime.parse(x['created_at']),
          cardType: x['card_type'],
          status: x['status'],
          merchantName: x['merchant_name'],
          currentSpend: (x['current_spend'] as num).toInt(),
          mainCardId: x['main_card_id'],
          gsi1Sk: x['GSI1SK'],
          name: x['name'],
          spendingLimit: (x['spending_limit'] as num).toInt(),
          updatedAt: DateTime.parse(x['updated_at']),
          gsi1Pk: x['GSI1PK'],
          allowedMerchants: List<String>.from(x['allowed_merchants']),
          startDate: DateTime.parse(x['start_date']),
          isLocked: x['is_locked'],
          expirationDate: DateTime.parse(x['expiration_date']),
          mainCardCurrency: x['main_card_currency'],
          durationDays: (x['duration_days'] as num).toInt(),
          sk: x['sk'],
          merchantId: x['merchant_id'],
          isActive: x['is_active'],
          pk: x['pk'],
          type: x['type'],
        ),
      ),
    ),
  );
}
