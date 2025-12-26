import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../endpoints.dart';

part 'image_upload_service.g.dart';

@RestApi(baseUrl: '')
abstract class ImageUploadService {
  factory ImageUploadService(Dio dio, {String? baseUrl}) = _ImageUploadService;

  /// Upload image to Core Service
  @POST(Endpoints.imageUpload)
  @MultiPart()
  Future<HttpResponse<dynamic>> uploadImage(
    @Part() File file,
    @Part() String category,
    @Part() String? metadata,
  );
}

