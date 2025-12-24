import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../endpoints.dart';

part 'linking_service.g.dart';

@RestApi(baseUrl: '')
abstract class LinkingService {
  factory LinkingService(Dio dio, {String? baseUrl}) = _LinkingService;

  /// Request OTP for parent linking
  @POST(Endpoints.linkRequestOtp)
  Future<HttpResponse<dynamic>> requestOtp(
    @Query('trialId') String trialId,
    @Body() Map<String, dynamic> request,
  );

  /// Verify OTP and link parent
  @POST(Endpoints.linkVerifyOtp)
  Future<HttpResponse<dynamic>> verifyOtp(
    @Query('trialId') String trialId,
    @Body() Map<String, dynamic> request,
  );

  /// Resend OTP for parent linking
  @POST(Endpoints.linkResendOtp)
  Future<HttpResponse<dynamic>> resendOtp(
    @Query('trialId') String trialId,
    @Body() Map<String, dynamic> request,
  );
}

