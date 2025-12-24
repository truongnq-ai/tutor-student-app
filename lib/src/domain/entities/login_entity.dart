interface class LoginEntity {}

class LoginRequestEntity extends LoginEntity {
  LoginRequestEntity({
    required this.username,
    required this.password,
    this.shouldRemeber = false,
  });

  final String username;
  final String password;
  final bool? shouldRemeber;
}

class LoginResponseEntity extends LoginEntity {
  LoginResponseEntity({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.refreshTokenExpiresIn,
  });

  final String accessToken;
  final String refreshToken;
  final String? tokenType;
  final int? expiresIn;
  final int? refreshTokenExpiresIn;
}
