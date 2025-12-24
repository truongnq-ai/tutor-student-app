import '../../domain/entities/sign_up_entity.dart';

extension SignUpRequestModel on SignUpRequestEntity {
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}

class SignUpResponseModel extends SignUpResponseEntity {
  SignUpResponseModel({
    required super.studentId,
    required super.username,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    // Backend returns StudentResponse with userId and username
    final userId = json['userId'] as String? ?? json['id'] as String?;
    final username = json['username'] as String? ?? '';
    
    return SignUpResponseModel(
      studentId: userId ?? '',
      username: username,
    );
  }
}
