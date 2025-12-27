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

  /// Check trial status (primary endpoint - backend decides NEW/ACTIVE/EXPIRED/CONSUMED)
  @POST(Endpoints.trialCheck)
  Future<HttpResponse<dynamic>> checkTrial(
    @Body() Map<String, dynamic> request,
  );

  /// Start trial (legacy - prefer checkTrial)
  @POST(Endpoints.trialStart)
  Future<HttpResponse<dynamic>> startTrial(
    @Body() Map<String, dynamic> request,
  );

  /// Get trial status (requires authentication)
  @GET(Endpoints.trialStatus)
  Future<HttpResponse<dynamic>> getTrialStatus();

  /// Create trial (requires authentication)
  @POST(Endpoints.trialCreate)
  Future<HttpResponse<dynamic>> createTrial(
    @Body() Map<String, dynamic> request,
  );

  // ==================== Grade & Learning Goals ====================

  /// Save grade selection (requires authentication)
  @POST(Endpoints.studentSaveGrade)
  Future<HttpResponse<dynamic>> saveGrade(
    @Body() Map<String, dynamic> request,
  );

  /// Get grade selection (requires authentication)
  @GET(Endpoints.studentGetGrade)
  Future<HttpResponse<dynamic>> getGrade();

  /// Save learning goals and create trial if not exists (requires authentication)
  /// Note: Grade must be included in request body when creating trial
  @POST(Endpoints.studentSaveLearningGoals)
  Future<HttpResponse<dynamic>> saveLearningGoals(
    @Body() Map<String, dynamic> request,
  );

  /// Get learning goals (requires authentication)
  @GET(Endpoints.studentGetLearningGoals)
  Future<HttpResponse<dynamic>> getLearningGoals();
}

