import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../endpoints.dart';

part 'learning_service.g.dart';

@RestApi(baseUrl: '')
abstract class LearningService {
  factory LearningService(Dio dio, {String? baseUrl}) = _LearningService;

  /// Get today's learning plan
  @GET(Endpoints.learningToday)
  Future<HttpResponse<dynamic>> getTodayLearningPlan();

  /// Get weak skills that need practice
  @GET(Endpoints.learningWeakSkills)
  Future<HttpResponse<dynamic>> getWeakSkills();
}

