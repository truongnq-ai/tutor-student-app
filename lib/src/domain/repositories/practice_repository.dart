import '../../core/base/response_object.dart';
import '../entities/practice_entity.dart';
import '../entities/session_info_entity.dart';

abstract class PracticeRepository {
  Future<ResponseObject<PracticeResponseEntity>> submitPractice({
    required String skillId,
    required String answer,
    int? durationSec,
    String? questionId,
    String? sessionId,
    String? sessionType,
  });

  Future<ResponseObject<Map<String, dynamic>>> getPracticeHistory({
    int page = 0,
    int pageSize = 20,
    String? skillId,
  });

  Future<ResponseObject<SessionInfoEntity>> getSessionInfo(String sessionId);
}

