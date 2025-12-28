import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/practice_session_entity.dart';
import '../../../../domain/entities/question_entity.dart';

part 'practice_session_provider.g.dart';

@riverpod
class PracticeSession extends _$PracticeSession {
  @override
  Future<PracticeSessionEntity?> build(String? sessionId) async {
    if (sessionId == null) return null;
    return _fetchSession(sessionId);
  }

  Future<PracticeSessionEntity?> _fetchSession(String sessionId) async {
    final response = await ref.read(practiceSessionRepositoryProvider).getSession(sessionId);
    if (response.isSuccess && response.data != null) {
      return response.data;
    } else {
      throw Exception(response.getErrorMessage());
    }
  }

  Future<void> createSession({
    required String skillId,
    required int totalQuestions,
    String? trialId,
  }) async {
    state = const AsyncValue.loading();

    try {
      final response = await ref.read(practiceSessionRepositoryProvider).createSession(
            skillId: skillId,
            totalQuestions: totalQuestions,
            trialId: trialId,
          );

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

  Future<void> pauseSession(String sessionId) async {
    try {
      final response = await ref.read(practiceSessionRepositoryProvider).pauseSession(sessionId);
      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
      } else {
        throw Exception(response.getErrorMessage());
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> resumeSession(String sessionId) async {
    try {
      final response = await ref.read(practiceSessionRepositoryProvider).resumeSession(sessionId);
      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
      } else {
        throw Exception(response.getErrorMessage());
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> completeSession(String sessionId) async {
    try {
      final response = await ref.read(practiceSessionRepositoryProvider).completeSession(sessionId);
      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
      } else {
        throw Exception(response.getErrorMessage());
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> cancelSession(String sessionId) async {
    try {
      final response = await ref.read(practiceSessionRepositoryProvider).cancelSession(sessionId);
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
class ResumableSessions extends _$ResumableSessions {
  @override
  Future<List<PracticeSessionEntity>> build() async {
    return _fetchResumableSessions();
  }

  Future<List<PracticeSessionEntity>> _fetchResumableSessions() async {
    final response = await ref.read(practiceSessionRepositoryProvider).getResumableSessions();
    if (response.isSuccess && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.getErrorMessage());
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchResumableSessions());
  }
}

@riverpod
class PracticeSessionQuestions extends _$PracticeSessionQuestions {
  @override
  Future<List<QuestionEntity>> build(String? sessionId) async {
    if (sessionId == null) return [];
    return _fetchQuestions(sessionId);
  }

  Future<List<QuestionEntity>> _fetchQuestions(String sessionId) async {
    final response = await ref.read(practiceSessionRepositoryProvider).getQuestionsInSession(sessionId);
    if (response.isSuccess && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.getErrorMessage());
    }
  }

  Future<void> refresh(String sessionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchQuestions(sessionId));
  }
}

