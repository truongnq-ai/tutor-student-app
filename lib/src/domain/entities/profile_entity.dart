import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String userId;
  final String username;
  final String? name;
  final String? email;
  final int? grade;
  final String status;
  final bool parentLinked;
  final String? parentId;
  final String? avatarUrl;

  const ProfileEntity({
    required this.userId,
    required this.username,
    this.name,
    this.email,
    this.grade,
    required this.status,
    required this.parentLinked,
    this.parentId,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [
        userId,
        username,
        name,
        email,
        grade,
        status,
        parentLinked,
        parentId,
        avatarUrl,
      ];
}

