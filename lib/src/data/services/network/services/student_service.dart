import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../endpoints.dart';

part 'student_service.g.dart';

@RestApi(baseUrl: '')
abstract class StudentService {
  factory StudentService(Dio dio, {String? baseUrl}) = _StudentService;

  // ==================== Authentication ====================

  /// Manual registration
  @POST(Endpoints.studentRegister)
  Future<HttpResponse<dynamic>> register(
    @Body() Map<String, dynamic> request,
  );

  /// Manual login
  @POST(Endpoints.studentLogin)
  Future<HttpResponse<dynamic>> login(
    @Body() Map<String, dynamic> request,
  );

  /// OAuth login (Google/Apple)
  @POST(Endpoints.studentOAuthLogin)
  Future<HttpResponse<dynamic>> oauthLogin(
    @Body() Map<String, dynamic> request,
  );

  /// Set credential after OAuth login
  @POST(Endpoints.studentSetCredential)
  Future<HttpResponse<dynamic>> setCredential(
    @Query('studentId') String studentId,
    @Body() Map<String, dynamic> request,
  );

  // ==================== Trial ====================

  /// Start trial
  @POST(Endpoints.trialStart)
  Future<HttpResponse<dynamic>> startTrial(
    @Body() Map<String, dynamic> request,
  );

  /// Get trial status
  @GET(Endpoints.trialStatus)
  Future<HttpResponse<dynamic>> getTrialStatus(
    @Header('X-Device-Id') String? deviceId,
    @Header('X-Anonymous-Id') String? anonymousId,
  );

  // ==================== Grade & Learning Goals ====================

  /// Save grade selection
  @POST(Endpoints.studentSaveGrade)
  Future<HttpResponse<dynamic>> saveGrade(
    @Query('trialId') String? trialId,
    @Query('anonymousId') String? anonymousId,
    @Body() Map<String, dynamic> request,
  );

  /// Get grade selection
  @GET(Endpoints.studentGetGrade)
  Future<HttpResponse<dynamic>> getGrade(
    @Query('trialId') String? trialId,
    @Query('anonymousId') String? anonymousId,
  );

  /// Save learning goals
  @POST(Endpoints.studentSaveLearningGoals)
  Future<HttpResponse<dynamic>> saveLearningGoals(
    @Query('trialId') String? trialId,
    @Query('anonymousId') String? anonymousId,
    @Body() Map<String, dynamic> request,
  );

  /// Get learning goals
  @GET(Endpoints.studentGetLearningGoals)
  Future<HttpResponse<dynamic>> getLearningGoals(
    @Query('trialId') String? trialId,
    @Query('anonymousId') String? anonymousId,
  );
}

