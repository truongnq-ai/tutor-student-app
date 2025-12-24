import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../endpoints.dart';

part 'learning_service.g.dart';

@RestApi(baseUrl: '')
abstract class LearningService {
  factory LearningService(Dio dio, {String? baseUrl}) = _LearningService;

  /// Get today's learning path
  @GET(Endpoints.learningToday)
  Future<HttpResponse<dynamic>> getTodayLearning(
    @Header('X-Device-Id') String? deviceId,
  );
}

