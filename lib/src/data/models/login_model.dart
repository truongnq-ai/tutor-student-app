import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/login_entity.dart';

part 'login_model.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.decode)
class LoginResponseModel extends LoginResponseEntity
    with LoginResponseModelMappable {
  LoginResponseModel({
    required super.accessToken,
    required super.refreshToken,
    super.tokenType,
    super.expiresIn,
    super.refreshTokenExpiresIn,
  });

  static const fromJson = LoginResponseModelMapper.fromJson;
}

@MappableClass(generateMethods: GenerateMethods.copy | GenerateMethods.encode)
class LoginRequestModel extends LoginRequestEntity
    with LoginRequestModelMappable {
  LoginRequestModel({required super.username, required super.password});

  factory LoginRequestModel.fromEntity(LoginRequestEntity entity) {
    return LoginRequestModel(
      username: entity.username,
      password: entity.password,
    );
  }
}
