class ConfirmForgotPasswordReq {
  final String email;
  final String code;
  final String password;

  ConfirmForgotPasswordReq({
    required this.email,
    required this.code,
    required this.password,
  });
}
