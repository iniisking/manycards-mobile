class DeleteSubcardRes {
  final bool success;
  final String message;
  final String cardId;

  DeleteSubcardRes({
    required this.success,
    required this.message,
    required this.cardId,
  });

  factory DeleteSubcardRes.fromJson(Map<String, dynamic> json) {
    return DeleteSubcardRes(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      cardId: json['card_id'] ?? '',
    );
  }
}
