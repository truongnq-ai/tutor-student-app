import 'dart:io';

import '../../core/base/response_object.dart';
import '../../domain/entities/image_upload_entity.dart';
import '../../domain/repositories/image_upload_repository.dart';
import '../models/image_upload_model.dart';
import '../services/network/services/image_upload_service.dart';

final class ImageUploadRepositoryImpl extends ImageUploadRepository {
  ImageUploadRepositoryImpl({
    required this.imageUploadService,
  });

  final ImageUploadService imageUploadService;

  @override
  Future<ResponseObject<ImageUploadEntity>> uploadImage({
    required String filePath,
    required String category,
    String? metadata,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return ResponseObject.error(
          errorCode: '4001',
          errorDetail: 'File does not exist',
        );
      }

      final response = await imageUploadService.uploadImage(
        file,
        category,
        metadata,
      );

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
          errorDetail: responseData.errorDetail ?? 'Failed to upload image',
        );
      }

      final uploadData = responseData.data;
      if (uploadData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final imageUpload = ImageUploadModel.fromJson(uploadData);
      return ResponseObject.success(imageUpload);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to upload image: ${e.toString()}',
      );
    }
  }
}

