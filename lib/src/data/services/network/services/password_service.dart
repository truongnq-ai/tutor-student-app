import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../endpoints.dart';

part 'password_service.g.dart';

@RestApi(baseUrl: '')
abstract class PasswordService {
  factory PasswordService(Dio dio, {String? baseUrl}) = _PasswordService;

  /// Change password
  @POST(Endpoints.studentChangePassword)
  Future<HttpResponse<dynamic>> changePassword(
    @Body() Map<String, dynamic> request,
  );
}

