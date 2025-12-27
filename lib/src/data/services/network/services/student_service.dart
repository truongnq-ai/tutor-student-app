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
  Future<HttpResponse<dynamic>> register(@Body() Map<String, dynamic> request);

  /// Manual login
  @POST(Endpoints.studentLogin)
  Future<HttpResponse<dynamic>> login(@Body() Map<String, dynamic> request);

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

  /// Check student status (trial and licence) - primary endpoint
  /// Returns one of 6 statuses: NO_TRIAL, TRIAL_ACTIVE_DEVICE_CONSUMED, TRIAL_ACTIVE,
  /// LICENCE_ACTIVE, LICENCE_EXPIRED, TRIAL_EXPIRED_NO_LICENCE
  @POST(Endpoints.studentCheck)
  Future<HttpResponse<dynamic>> checkStudentStatus(
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

  /// Get grade selection (requires authentication)
  @GET(Endpoints.studentGetGrade)
  Future<HttpResponse<dynamic>> getGrade();

  /// Get learning goals (requires authentication)
  @GET(Endpoints.studentGetLearningGoals)
  Future<HttpResponse<dynamic>> getLearningGoals();
}
