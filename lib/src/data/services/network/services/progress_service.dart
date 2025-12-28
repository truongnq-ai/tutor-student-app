import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../endpoints.dart';

part 'progress_service.g.dart';

@RestApi(baseUrl: '')
abstract class ProgressService {
  factory ProgressService(Dio dio, {String? baseUrl}) = _ProgressService;

  /// Get progress dashboard
  @GET(Endpoints.progressDashboard)
  Future<HttpResponse<dynamic>> getProgressDashboard(
    @Query('trialId') String? trialId,
  );

  /// Get skill detail
  @GET(Endpoints.progressSkillDetail)
  Future<HttpResponse<dynamic>> getSkillDetail(
    @Path('skillId') String skillId,
    @Query('trialId') String? trialId,
  );

  /// Get weak skills
  @GET(Endpoints.progressWeakSkills)
  Future<HttpResponse<dynamic>> getWeakSkills(
    @Query('limit') int? limit,
    @Query('trialId') String? trialId,
  );

  /// Get recommendations
  @GET(Endpoints.progressRecommendations)
  Future<HttpResponse<dynamic>> getRecommendations(
    @Query('trialId') String? trialId,
  );
}

