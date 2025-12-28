import '../../core/base/response_object.dart';
import '../entities/learning_entity.dart';
import '../entities/weak_skill_entity.dart';

abstract class LearningRepository {
  Future<ResponseObject<LearningPlanEntity>> getTodayLearningPlan();
  Future<ResponseObject<List<WeakSkillEntity>>> getWeakSkills({
    int limit = 10,
    int offset = 0,
  });
}

