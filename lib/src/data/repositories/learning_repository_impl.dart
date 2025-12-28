import 'package:logger/logger.dart';

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
    Logger? logger,
  }) : _logger = logger ?? Logger();

  final LearningService learningService;
  final Logger _logger;

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
          errorDetail:
              responseData.errorDetail ?? 'Failed to get learning plan',
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
      
      // Validation: Check if chapter exists but skills are empty
      if (learningPlan.recommendedChapter != null) {
        final chapter = learningPlan.recommendedChapter!;
        if (chapter.skills.isEmpty) {
          // Log warning for debugging - chapter exists but no skills
          // This is not necessarily an error, but worth logging
          _logger.w(
            'Learning plan chapter has no skills',
            error: 'Chapter: ${chapter.chapterName ?? chapter.chapterId}, '
                'ChapterId: ${chapter.chapterId}',
          );
        }
      }
      
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
      final response = await learningService.getWeakSkills(limit, offset);

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
