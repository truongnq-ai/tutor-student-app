import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../endpoints.dart';

part 'settings_service.g.dart';

@RestApi(baseUrl: '')
abstract class SettingsService {
  factory SettingsService(Dio dio, {String? baseUrl}) = _SettingsService;

  /// Get student settings
  @GET(Endpoints.studentSettingsGet)
  Future<HttpResponse<dynamic>> getSettings();

  /// Update student settings
  @PUT(Endpoints.studentSettingsUpdate)
  Future<HttpResponse<dynamic>> updateSettings(
    @Body() Map<String, dynamic> request,
  );
}

