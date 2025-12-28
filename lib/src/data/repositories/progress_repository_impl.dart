import '../../core/base/response_object.dart';
import '../../domain/entities/progress_dashboard_entity.dart';
import '../../domain/entities/recommendation_entity.dart';
import '../../domain/entities/skill_detail_entity.dart';
import '../../domain/entities/weak_skill_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import '../models/progress_dashboard_model.dart';
import '../models/recommendation_model.dart';
import '../models/skill_detail_model.dart';
import '../models/weak_skill_model.dart';
import '../services/network/services/progress_service.dart';

final class ProgressRepositoryImpl extends ProgressRepository {
  ProgressRepositoryImpl({
    required this.progressService,
  });

  final ProgressService progressService;

  @override
  Future<ResponseObject<ProgressDashboardEntity>> getProgressDashboard({
    String? trialId,
  }) async {
    try {
      final response = await progressService.getProgressDashboard(
        trialId,
      );

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to get progress dashboard',
        );
      }

      final dashboardData = responseData.data;
      if (dashboardData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final dashboard = ProgressDashboardModel.fromJson(dashboardData);
      return ResponseObject.success(dashboard);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get progress dashboard: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<SkillDetailEntity>> getSkillDetail({
    required String skillId,
    String? trialId,
  }) async {
    try {
      final response = await progressService.getSkillDetail(
        skillId,
        trialId,
      );

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to get skill detail',
        );
      }

      final skillData = responseData.data;
      if (skillData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final skillDetail = SkillDetailModel.fromJson(skillData);
      return ResponseObject.success(skillDetail);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get skill detail: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<List<WeakSkillEntity>>> getWeakSkills({
    int limit = 5,
    String? trialId,
  }) async {
    try {
      final response = await progressService.getWeakSkills(
        limit,
        trialId,
      );

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<List<dynamic>>.fromJson(
        responseMap,
        (data) => data is List ? data : <dynamic>[],
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to get weak skills',
        );
      }

      final skillsData = responseData.data;
      if (skillsData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final weakSkills = skillsData
          .map((item) => WeakSkillModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return ResponseObject.success(weakSkills);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get weak skills: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<RecommendationEntity>> getRecommendations({
    String? trialId,
  }) async {
    try {
      final response = await progressService.getRecommendations(
        trialId,
      );

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to get recommendations',
        );
      }

      final recommendationData = responseData.data;
      if (recommendationData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final recommendations = RecommendationModel.fromJson(recommendationData);
      return ResponseObject.success(recommendations);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get recommendations: ${e.toString()}',
      );
    }
  }
}

