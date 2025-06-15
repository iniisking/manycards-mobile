class FundAccountRes {
  final bool success;
  final String authorizationUrl;
  final String accessCode;
  final String reference;
  final String message;

  FundAccountRes({
    required this.success,
    required this.authorizationUrl,
    required this.accessCode,
    required this.reference,
    required this.message,
  });

  factory FundAccountRes.fromJson(Map<String, dynamic> json) {
    return FundAccountRes(
      success: json['success'] as bool,
      authorizationUrl: json['authorization_url'] as String,
      accessCode: json['access_code'] as String,
      reference: json['reference'] as String,
      message: json['message'] as String,
    );
  }
}
