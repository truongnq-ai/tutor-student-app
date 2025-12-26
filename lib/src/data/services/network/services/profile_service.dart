import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../endpoints.dart';

part 'profile_service.g.dart';

@RestApi(baseUrl: '')
abstract class ProfileService {
  factory ProfileService(Dio dio, {String? baseUrl}) = _ProfileService;

  /// Get current student profile
  @GET(Endpoints.studentProfileGet)
  Future<HttpResponse<dynamic>> getProfile();

  /// Update student profile
  @PUT(Endpoints.studentProfileUpdate)
  Future<HttpResponse<dynamic>> updateProfile(
    @Body() Map<String, dynamic> request,
  );

  /// Upload avatar
  @POST(Endpoints.studentProfileAvatar)
  @MultiPart()
  Future<HttpResponse<dynamic>> uploadAvatar(
    @Part() File file,
  );
}

