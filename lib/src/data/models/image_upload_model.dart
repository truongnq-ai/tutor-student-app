import '../../domain/entities/image_upload_entity.dart';

class ImageUploadModel extends ImageUploadEntity {
  ImageUploadModel({
    required super.publicId,
    required super.imageUrl,
    required super.category,
    required super.uploadedAt,
  });

  factory ImageUploadModel.fromJson(Map<String, dynamic> json) {
    return ImageUploadModel(
      publicId: json['publicId'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'publicId': publicId,
      'imageUrl': imageUrl,
      'category': category,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}

