import '../../core/base/response_object.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ResponseObject<ProfileEntity>> getProfile();
  
  Future<ResponseObject<ProfileEntity>> updateProfile({
    String? name,
    String? avatarUrl,
  });
  
  Future<ResponseObject<String>> uploadAvatar(String imagePath);
}

