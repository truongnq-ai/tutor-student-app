import '../../core/base/response_object.dart';
import '../entities/progress_dashboard_entity.dart';
import '../entities/recommendation_entity.dart';
import '../entities/skill_detail_entity.dart';
import 'weak_skill_entity.dart';

abstract class ProgressRepository {
  Future<ResponseObject<ProgressDashboardEntity>> getProgressDashboard({
    String? trialId,
    String? anonymousId,
  });

  Future<ResponseObject<SkillDetailEntity>> getSkillDetail({
    required String skillId,
    String? trialId,
    String? anonymousId,
  });

  Future<ResponseObject<List<WeakSkillEntity>>> getWeakSkills({
    int limit = 5,
    String? trialId,
    String? anonymousId,
  });

  Future<ResponseObject<RecommendationEntity>> getRecommendations({
    String? trialId,
    String? anonymousId,
  });
}

