class ImageUploadEntity {
  final String publicId;
  final String imageUrl;
  final String category;
  final DateTime uploadedAt;

  ImageUploadEntity({
    required this.publicId,
    required this.imageUrl,
    required this.category,
    required this.uploadedAt,
  });
}

