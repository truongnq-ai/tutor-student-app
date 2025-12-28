import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../endpoints.dart';

part 'mini_test_service.g.dart';

@RestApi(baseUrl: '')
abstract class MiniTestService {
  factory MiniTestService(Dio dio, {String? baseUrl}) = _MiniTestService;

  /// Start mini test
  @POST(Endpoints.miniTestStart)
  Future<HttpResponse<dynamic>> startMiniTest(
    @Body() Map<String, dynamic> request,
  );

  /// Get mini test session
  @GET(Endpoints.miniTestSessionGet)
  Future<HttpResponse<dynamic>> getTestSession(
    @Path('sessionId') String sessionId,
  );

  /// Submit answer
  @POST(Endpoints.miniTestSubmitAnswer)
  Future<HttpResponse<dynamic>> submitAnswer(
    @Path('sessionId') String sessionId,
    @Body() Map<String, dynamic> request,
  );

  /// Submit mini test
  @POST(Endpoints.miniTestSubmit)
  Future<HttpResponse<dynamic>> submitTest(
    @Path('sessionId') String sessionId,
  );

  /// Check unlock condition
  @GET(Endpoints.miniTestUnlock)
  Future<HttpResponse<dynamic>> checkUnlock(
    @Path('chapterId') String chapterId,
  );
}

