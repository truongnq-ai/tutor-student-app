import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/base/response_object.dart';
import '../endpoints.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: '')
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl = ''}) = _AuthService;

  /// Refresh access token
  @GET(Endpoints.refreshToken)
  Future<HttpResponse<ResponseObject<Map<String, dynamic>>>> refreshToken();

  /// Logout
  @POST(Endpoints.logout)
  Future<HttpResponse<ResponseObject<void>>> logout();
}

