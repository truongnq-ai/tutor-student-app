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

  /// Start a mini test and return the session directly
  /// This avoids race conditions from delay + read pattern
  Future<MiniTestSessionEntity> startTest({required String chapterId}) async {
    state = const AsyncValue.loading();

    try {
      final response = await ref.read(miniTestRepositoryProvider).startTest(chapterId: chapterId);

      if (response.isSuccess && response.data != null) {
        final session = response.data!;
        state = AsyncValue.data(session);
        return session;
      } else {
        final errorMessage = response.getErrorMessage();
        final error = Exception(errorMessage);
        state = AsyncValue.error(
          error,
          StackTrace.current,
        );
        throw error;
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
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

  /// Cleanup method - explicitly reset state when test is completed
  void cleanup() {
    state = const AsyncValue.data(null);
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
  Future<bool> build(String chapterId) async {
    return _checkUnlock(chapterId);
  }

  Future<bool> _checkUnlock(String chapterId) async {
    // Validate chapterId
    if (chapterId.isEmpty) {
      throw Exception('Chapter ID không hợp lệ');
    }

    try {
      final response = await ref.read(miniTestRepositoryProvider).checkUnlock(chapterId);
      if (response.isSuccess && response.data != null) {
        return response.data!;
      } else {
        final errorMessage = response.getErrorMessage();
        throw Exception(errorMessage.isNotEmpty 
            ? errorMessage 
            : 'Không thể kiểm tra trạng thái mở khóa mini test');
      }
    } catch (e) {
      // Re-throw with more context if needed
      if (e is Exception) {
        throw e;
      }
      throw Exception('Lỗi khi kiểm tra trạng thái mở khóa: ${e.toString()}');
    }
  }

  Future<void> refresh(String chapterId) async {
    // Validate before refreshing
    if (chapterId.isEmpty) {
      state = AsyncValue.error(
        Exception('Chapter ID không hợp lệ'),
        StackTrace.current,
      );
      return;
    }
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _checkUnlock(chapterId));
  }
}

