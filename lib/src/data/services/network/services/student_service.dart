import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/base/response_object.dart';
import '../endpoints.dart';

part 'student_service.g.dart';

@RestApi(baseUrl: '')
abstract class StudentService {
  factory StudentService(Dio dio, {String baseUrl = ''}) = _StudentService;

  // ==================== Authentication ====================

  /// Manual registration
  @POST(Endpoints.studentRegister)
  Future<HttpResponse<ResponseObject<Map<String, dynamic>>>> register(
    @Body() Map<String, dynamic> request,
  );

  /// Manual login
  @POST(Endpoints.studentLogin)
  Future<HttpResponse<ResponseObject<Map<String, dynamic>>>> login(
    @Body() Map<String, dynamic> request,
  );

  /// OAuth login (Google/Apple)
  @POST(Endpoints.studentOAuthLogin)
  Future<HttpResponse<ResponseObject<Map<String, dynamic>>>> oauthLogin(
    @Body() Map<String, dynamic> request,
  );

  /// Set credential after OAuth login
  @POST(Endpoints.studentSetCredential)
  Future<HttpResponse<ResponseObject<Map<String, dynamic>>>> setCredential(
    @Body() Map<String, dynamic> request,
  );

  // ==================== Trial ====================

  /// Start trial
  @POST(Endpoints.trialStart)
  Future<HttpResponse<ResponseObject<Map<String, dynamic>>>> startTrial(
    @Body() Map<String, dynamic> request,
  );

  /// Get trial status
  @GET(Endpoints.trialStatus)
  Future<HttpResponse<ResponseObject<Map<String, dynamic>>>> getTrialStatus(
    @Header('X-Device-Id') String? deviceId,
    @Header('X-Anonymous-Id') String? anonymousId,
  );
}

