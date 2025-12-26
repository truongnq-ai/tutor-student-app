import '../../core/base/response_object.dart';
import '../entities/tutor_entity.dart';

abstract class TutorRepository {
  /// Solve math problem from image URL
  Future<ResponseObject<SolveResponseEntity>> solveFromImage({
    required String imageUrl,
    required int grade,
    String? trialId,
    String? anonymousId,
  });

  /// Solve math problem from text
  Future<ResponseObject<SolveResponseEntity>> solveFromText({
    required String problemText,
    required int grade,
    String? trialId,
    String? anonymousId,
  });

  /// Get recent solved problems
  Future<ResponseObject<Map<String, dynamic>>> getRecentProblems({
    int page = 0,
    int pageSize = 10,
    String? trialId,
    String? anonymousId,
  });
}

