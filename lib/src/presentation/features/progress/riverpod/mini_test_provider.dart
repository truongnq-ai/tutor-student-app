import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/mini_test_result_entity.dart';
import '../../../../domain/entities/mini_test_session_entity.dart';

part 'mini_test_provider.g.dart';

@riverpod
class MiniTestSession extends _$MiniTestSession {
  @override
  Future<MiniTestSessionEntity?> build(String? sessionId) async {
    if (sessionId == null) return null;
    return _fetchSession(sessionId);
  }

  Future<MiniTestSessionEntity?> _fetchSession(String sessionId) async {
    final response = await ref.read(miniTestRepositoryProvider).getTestSession(sessionId);
    if (response.isSuccess && response.data != null) {
      return response.data;
    } else {
      throw Exception(response.getErrorMessage());
    }
  }

  Future<void> startTest({required String skillId}) async {
    state = const AsyncValue.loading();

    try {
      final response = await ref.read(miniTestRepositoryProvider).startTest(skillId: skillId);

      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
      } else {
        final errorMessage = response.getErrorMessage();
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> submitAnswer({
    required String sessionId,
    required int questionIndex,
    required String answer,
  }) async {
    try {
      final response = await ref.read(miniTestRepositoryProvider).submitAnswer(
            sessionId: sessionId,
            questionIndex: questionIndex,
            answer: answer,
          );
      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
      } else {
        throw Exception(response.getErrorMessage());
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh(String sessionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchSession(sessionId));
  }
}

@riverpod
class MiniTestResult extends _$MiniTestResult {
  @override
  Future<MiniTestResultEntity?> build() async {
    return null;
  }

  Future<void> submitTest(String sessionId) async {
    state = const AsyncValue.loading();

    try {
      final response = await ref.read(miniTestRepositoryProvider).submitTest(sessionId);

      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
      } else {
        final errorMessage = response.getErrorMessage();
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

@riverpod
class MiniTestUnlock extends _$MiniTestUnlock {
  @override
  Future<bool> build(String skillId) async {
    return _checkUnlock(skillId);
  }

  Future<bool> _checkUnlock(String skillId) async {
    final response = await ref.read(miniTestRepositoryProvider).checkUnlock(skillId);
    if (response.isSuccess && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.getErrorMessage());
    }
  }

  Future<void> refresh(String skillId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _checkUnlock(skillId));
  }
}

