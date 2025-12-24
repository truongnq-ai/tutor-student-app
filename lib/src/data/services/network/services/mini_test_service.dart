import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/base/response_object.dart';
import '../endpoints.dart';

part 'mini_test_service.g.dart';

@RestApi(baseUrl: '')
abstract class MiniTestService {
  factory MiniTestService(Dio dio, {String baseUrl = ''}) = _MiniTestService;

  /// Start mini test
  @POST(Endpoints.miniTestStart)
  Future<HttpResponse<ResponseObject<Map<String, dynamic>>>> startMiniTest(
    @Body() Map<String, dynamic> request,
  );

  /// Submit mini test answers
  @POST(Endpoints.miniTestSubmit)
  Future<HttpResponse<ResponseObject<Map<String, dynamic>>>> submitMiniTest(
    @Body() Map<String, dynamic> request,
  );
}

