import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/base/response_object.dart';
import '../endpoints.dart';

part 'linking_service.g.dart';

@RestApi(baseUrl: '')
abstract class LinkingService {
  factory LinkingService(Dio dio, {String baseUrl = ''}) = _LinkingService;

  /// Request OTP for parent linking
  @POST(Endpoints.linkRequestOtp)
  Future<HttpResponse<ResponseObject<Map<String, dynamic>>>> requestOtp(
    @Body() Map<String, dynamic> request,
  );

  /// Verify OTP and link parent
  @POST(Endpoints.linkVerifyOtp)
  Future<HttpResponse<ResponseObject<Map<String, dynamic>>>> verifyOtp(
    @Body() Map<String, dynamic> request,
  );

  /// Confirm link (parent-first flow)
  @POST(Endpoints.linkConfirm)
  Future<HttpResponse<ResponseObject<Map<String, dynamic>>>> confirmLink(
    @Body() Map<String, dynamic> request,
  );
}

