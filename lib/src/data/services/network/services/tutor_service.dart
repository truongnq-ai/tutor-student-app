import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../endpoints.dart';

part 'tutor_service.g.dart';

@RestApi(baseUrl: '')
abstract class TutorService {
  factory TutorService(Dio dio, {String? baseUrl}) = _TutorService;

  /// Solve math problem from image URL
  @POST(Endpoints.tutorSolveImage)
  Future<HttpResponse<dynamic>> solveImage(
    @Body() Map<String, dynamic> request,
    @Query('trialId') String? trialId,
  );

  /// Solve math problem from text
  @POST(Endpoints.tutorSolveText)
  Future<HttpResponse<dynamic>> solveText(
    @Body() Map<String, dynamic> request,
    @Query('trialId') String? trialId,
  );

  /// Get recent solved problems
  @GET(Endpoints.tutorRecentProblems)
  Future<HttpResponse<dynamic>> getRecentProblems(
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
    @Query('trialId') String? trialId,
  );
}

