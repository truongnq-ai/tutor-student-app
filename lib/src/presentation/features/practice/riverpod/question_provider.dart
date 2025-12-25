import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/question_entity.dart';

part 'question_provider.g.dart';

@riverpod
class CurrentQuestion extends _$CurrentQuestion {
  @override
  Future<QuestionEntity?> build() async {
    return null;
  }

  Future<bool> loadQuestion(String questionId) async {
    if (state.isLoading) return false;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(questionRepositoryProvider).getQuestionById(questionId);

      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
        return true;
      } else {
        final errorMessage = response.getErrorMessage();
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
        return false;
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<bool> submitAnswer({
    required String questionId,
    required String answer,
    int? durationSec,
  }) async {
    if (state.isLoading) return false;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(questionRepositoryProvider).submitQuestionAnswer(
            questionId: questionId,
            answer: answer,
            durationSec: durationSec,
          );

      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
        return true;
      } else {
        final errorMessage = response.getErrorMessage();
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
        return false;
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

