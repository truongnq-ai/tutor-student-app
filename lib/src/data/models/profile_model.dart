import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/profile_entity.dart';

part 'profile_model.mapper.dart';

@MappableClass()
class ProfileModel extends ProfileEntity with ProfileModelMappable {
  const ProfileModel({
    required super.userId,
    required super.username,
    super.name,
    super.email,
    super.grade,
    required super.status,
    required super.parentLinked,
    super.parentId,
    super.avatarUrl,
  });

  static const fromJson = ProfileModelMapper.fromJson;
}

