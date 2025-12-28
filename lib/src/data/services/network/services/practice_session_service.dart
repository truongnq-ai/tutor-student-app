import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../endpoints.dart';

part 'practice_session_service.g.dart';

@RestApi(baseUrl: '')
abstract class PracticeSessionService {
  factory PracticeSessionService(Dio dio, {String? baseUrl}) = _PracticeSessionService;

  /// Create practice session
  @POST(Endpoints.practiceSessionCreate)
  Future<HttpResponse<dynamic>> createSession(
    @Body() Map<String, dynamic> request,
    @Query('trialId') String? trialId,
  );

  /// Get practice session
  @GET(Endpoints.practiceSessionGet)
  Future<HttpResponse<dynamic>> getSession(
    @Path('sessionId') String sessionId,
  );

  /// Get questions in practice session
  @GET(Endpoints.practiceSessionQuestions)
  Future<HttpResponse<dynamic>> getQuestionsInSession(
    @Path('sessionId') String sessionId,
  );

  /// Pause practice session
  @PUT(Endpoints.practiceSessionPause)
  Future<HttpResponse<dynamic>> pauseSession(
    @Path('sessionId') String sessionId,
  );

  /// Resume practice session
  @PUT(Endpoints.practiceSessionResume)
  Future<HttpResponse<dynamic>> resumeSession(
    @Path('sessionId') String sessionId,
  );

  /// Complete practice session
  @PUT(Endpoints.practiceSessionComplete)
  Future<HttpResponse<dynamic>> completeSession(
    @Path('sessionId') String sessionId,
  );

  /// Cancel practice session
  @DELETE(Endpoints.practiceSessionCancel)
  Future<HttpResponse<dynamic>> cancelSession(
    @Path('sessionId') String sessionId,
  );

  /// Get resumable sessions
  @GET(Endpoints.practiceSessionResumable)
  Future<HttpResponse<dynamic>> getResumableSessions(
    @Query('trialId') String? trialId,
  );
}

