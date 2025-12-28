import '../../core/base/response_object.dart';
import '../../domain/entities/learning_entity.dart';
import '../../domain/entities/weak_skill_entity.dart';
import '../../domain/repositories/learning_repository.dart';
import '../models/learning_model.dart';
import '../models/weak_skill_model.dart';
import '../services/network/services/learning_service.dart';

final class LearningRepositoryImpl extends LearningRepository {
  LearningRepositoryImpl({
    required this.learningService,
  });

  final LearningService learningService;

  @override
  Future<ResponseObject<LearningPlanEntity>> getTodayLearningPlan() async {
    try {
      final response = await learningService.getTodayLearningPlan();

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
          errorDetail: responseData.errorDetail ?? 'Failed to get learning plan',
        );
      }

      final learningData = responseData.data;
      if (learningData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final learningPlan = LearningPlanModel.fromJson(learningData);
      return ResponseObject.success(learningPlan);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get learning plan: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<List<WeakSkillEntity>>> getWeakSkills({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await learningService.getWeakSkills(
        limit: limit,
        offset: offset,
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
        (data) => data is List ? data : [],
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to get weak skills',
        );
      }

      final skillsData = responseData.data ?? [];
      final weakSkills = skillsData
          .map((e) => WeakSkillModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return ResponseObject.success(weakSkills);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get weak skills: ${e.toString()}',
      );
    }
  }
}

