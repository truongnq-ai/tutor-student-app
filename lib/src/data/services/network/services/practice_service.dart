import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../endpoints.dart';

part 'practice_service.g.dart';

@RestApi(baseUrl: '')
abstract class PracticeService {
  factory PracticeService(Dio dio, {String? baseUrl}) = _PracticeService;

  /// Submit practice answer
  @POST(Endpoints.practiceSubmit)
  Future<HttpResponse<dynamic>> submitPractice(
    @Body() Map<String, dynamic> request,
  );

  /// Get practice history
  @GET(Endpoints.practiceHistory)
  Future<HttpResponse<dynamic>> getPracticeHistory(
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
    @Query('skillId') String? skillId,
    @Query('fromDate') String? fromDate,
    @Query('toDate') String? toDate,
  );

  /// Get practice questions
  @GET(Endpoints.practiceQuestions)
  Future<HttpResponse<dynamic>> getPracticeQuestions(
    @Query('status') String? status,
    @Query('skillId') String? skillId,
    @Query('limit') int? limit,
    @Header('X-Device-Id') String? deviceId,
  );

  /// Get practice question detail
  @GET(Endpoints.practiceQuestionDetail)
  Future<HttpResponse<dynamic>> getPracticeQuestionDetail(
    @Path('id') String questionId,
  );

  /// Submit practice question answer
  @POST(Endpoints.practiceQuestionSubmit)
  Future<HttpResponse<dynamic>> submitPracticeQuestion(
    @Path('id') String questionId,
    @Body() Map<String, dynamic> request,
  );
}

