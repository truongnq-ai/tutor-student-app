import '../../core/base/response_object.dart';
import '../entities/chapter_progress_entity.dart';
import '../entities/progress_dashboard_entity.dart';
import '../entities/recommendation_entity.dart';
import '../entities/skill_detail_entity.dart';
import '../entities/weak_skill_entity.dart';

abstract class ProgressRepository {
  Future<ResponseObject<ProgressDashboardEntity>> getProgressDashboard({
    String? trialId,
  });

  Future<ResponseObject<SkillDetailEntity>> getSkillDetail({
    required String skillId,
    String? trialId,
  });

  Future<ResponseObject<List<WeakSkillEntity>>> getWeakSkills({
    int limit = 5,
    String? trialId,
  });

  Future<ResponseObject<RecommendationEntity>> getRecommendations({
    String? trialId,
  });

  Future<ResponseObject<ChapterProgressEntity>> getChapterProgress({
    required String chapterId,
  });

  Future<ResponseObject<List<ChapterProgressEntity>>> getAllChapterProgress({
    required int grade,
  });
}

