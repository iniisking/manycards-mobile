class CreateSubcardRes {
  final bool error;
  final String message;
  final Data data;

  CreateSubcardRes({
    required this.error,
    required this.message,
    required this.data,
  });
}

class Data {
  final String subCardId;
  final String name;
  final String cardType;
  final bool isLocked;
  final String merchantId;
  final String merchantName;
  final List<String> allowedMerchants;
  final int spendingLimit;
  final int currentSpend;
  final bool status;
  final String parentCardId;
  final String currency;
  final DateTime createdAt;
  final DateTime expirationDate;

  Data({
    required this.subCardId,
    required this.name,
    required this.cardType,
    required this.isLocked,
    required this.merchantId,
    required this.merchantName,
    required this.allowedMerchants,
    required this.spendingLimit,
    required this.currentSpend,
    required this.status,
    required this.parentCardId,
    required this.currency,
    required this.createdAt,
    required this.expirationDate,
  });
}

CreateSubcardRes createSubcardResFromJson(Map<String, dynamic> json) {
  return CreateSubcardRes(
    error: json['error'] ?? false,
    message: json['message'] ?? '',
    data: Data(
      subCardId: json['data']['subCardId'] ?? '',
      name: json['data']['name'] ?? '',
      cardType: json['data']['cardType'] ?? '',
      isLocked: json['data']['isLocked'] ?? false,
      merchantId: json['data']['merchantId'] ?? '',
      merchantName: json['data']['merchantName'] ?? '',
      allowedMerchants: List<String>.from(
        json['data']['allowedMerchants'] ?? [],
      ),
      spendingLimit: json['data']['spendingLimit'] ?? 0,
      currentSpend: json['data']['currentSpend'] ?? 0,
      status: json['data']['status'] ?? false,
      parentCardId: json['data']['parentCardId'] ?? '',
      currency: json['data']['currency'] ?? '',
      createdAt: DateTime.parse(json['data']['createdAt']),
      expirationDate: DateTime.parse(json['data']['expirationDate']),
    ),
  );
}
