import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/practice_entity.dart';

part 'practice_provider.g.dart';

@riverpod
class PracticeSubmission extends _$PracticeSubmission {
  @override
  Future<PracticeResponseEntity?> build() async {
    return null;
  }

  Future<bool> submitPractice({
    required String skillId,
    required String answer,
    int? durationSec,
    String? questionId,
    String? sessionId,
    String? sessionType,
  }) async {
    if (state.isLoading) return false;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(practiceRepositoryProvider).submitPractice(
            skillId: skillId,
            answer: answer,
            durationSec: durationSec,
            questionId: questionId,
            sessionId: sessionId,
            sessionType: sessionType,
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

@riverpod
class PracticeHistory extends _$PracticeHistory {
  @override
  Future<Map<String, dynamic>?> build() async {
    return null;
  }

  Future<bool> loadHistory({
    int page = 0,
    int pageSize = 20,
    String? skillId,
  }) async {
    if (state.isLoading) return false;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(practiceRepositoryProvider).getPracticeHistory(
            page: page,
            pageSize: pageSize,
            skillId: skillId,
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

