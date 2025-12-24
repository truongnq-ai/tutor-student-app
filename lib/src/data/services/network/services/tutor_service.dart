import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../endpoints.dart';

part 'tutor_service.g.dart';

@RestApi(baseUrl: '')
abstract class TutorService {
  factory TutorService(Dio dio, {String baseUrl = ''}) = _TutorService;

  /// Solve math problem from image
  @POST(Endpoints.tutorSolveImage)
  @MultiPart()
  Future<HttpResponse<Map<String, dynamic>>> solveImage(
    @Part() File image,
    @Part() int grade,
  );

  /// Solve math problem from text
  @POST(Endpoints.tutorSolveText)
  Future<HttpResponse<Map<String, dynamic>>> solveText(
    @Body() Map<String, dynamic> request,
  );
}

