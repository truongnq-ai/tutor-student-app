import '../../core/base/response_object.dart';
import '../entities/question_entity.dart';

abstract class QuestionRepository {
  Future<ResponseObject<QuestionEntity>> getQuestionById(String questionId);
  Future<ResponseObject<List<QuestionEntity>>> getQuestionsBySession(String sessionId);
  Future<ResponseObject<QuestionEntity>> submitQuestionAnswer({
    required String questionId,
    required String answer,
    int? durationSec,
  });
}

