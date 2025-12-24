interface class SignUpEntity {}

class SignUpRequestEntity extends SignUpEntity {
  SignUpRequestEntity({
    required this.name,
    required this.username,
    required this.password,
    required this.confirmPassword,
  });

  final String name;
  final String username;
  final String password;
  final String confirmPassword;
}

class SignUpResponseEntity extends SignUpEntity {
  SignUpResponseEntity({
    required this.studentId,
    required this.username,
  });

  final String studentId;
  final String username;
}
