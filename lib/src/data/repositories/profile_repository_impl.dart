import 'dart:io';

import '../../core/base/response_object.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';
import '../services/network/services/profile_service.dart';

final class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRepositoryImpl({
    required this.profileService,
  });

  final ProfileService profileService;

  @override
  Future<ResponseObject<ProfileEntity>> getProfile() async {
    try {
      final response = await profileService.getProfile();

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to get profile',
        );
      }

      final profileData = responseData.data;
      if (profileData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final profile = ProfileModel.fromJson(profileData);
      return ResponseObject.success(profile);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get profile: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<ProfileEntity>> updateProfile({
    String? name,
    String? avatarUrl,
  }) async {
    try {
      final requestBody = <String, dynamic>{};
      if (name != null) {
        requestBody['name'] = name;
      }
      if (avatarUrl != null) {
        requestBody['avatarUrl'] = avatarUrl;
      }

      final response = await profileService.updateProfile(requestBody);

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to update profile',
        );
      }

      final profileData = responseData.data;
      if (profileData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final profile = ProfileModel.fromJson(profileData);
      return ResponseObject.success(profile);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to update profile: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<String>> uploadAvatar(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        return ResponseObject.error(
          errorCode: '4001',
          errorDetail: 'File not found',
        );
      }

      final response = await profileService.uploadAvatar(file);

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<String>.fromJson(
        responseMap,
        (data) => data is String ? data : '',
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to upload avatar',
        );
      }

      final avatarUrl = responseData.data;
      if (avatarUrl == null || avatarUrl.isEmpty) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No avatar URL in response',
        );
      }

      return ResponseObject.success(avatarUrl);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to upload avatar: ${e.toString()}',
      );
    }
  }
}

