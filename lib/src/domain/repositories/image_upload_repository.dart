import '../../core/base/response_object.dart';
import '../entities/image_upload_entity.dart';

abstract class ImageUploadRepository {
  /// Upload image to Core Service
  Future<ResponseObject<ImageUploadEntity>> uploadImage({
    required String filePath,
    required String category,
    String? metadata,
  });
}

