import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/tutor_entity.dart';

part 'tutor_provider.g.dart';

@riverpod
class SolveProblem extends _$SolveProblem {
  @override
  Future<SolveResponseEntity?> build() async {
    return null;
  }

  Future<bool> solveFromImage({
    required String imageUrl,
    required int grade,
    String? trialId,
  }) async {
    if (state.isLoading) return false;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(tutorRepositoryProvider).solveFromImage(
            imageUrl: imageUrl,
            grade: grade,
            trialId: trialId,
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

  Future<bool> solveFromText({
    required String problemText,
    required int grade,
    String? trialId,
  }) async {
    if (state.isLoading) return false;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(tutorRepositoryProvider).solveFromText(
            problemText: problemText,
            grade: grade,
            trialId: trialId,
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
class RecentProblems extends _$RecentProblems {
  @override
  Future<Map<String, dynamic>?> build() async {
    return null;
  }

  Future<bool> loadRecentProblems({
    int page = 0,
    int pageSize = 10,
    String? trialId,
  }) async {
    if (state.isLoading) return false;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(tutorRepositoryProvider).getRecentProblems(
            page: page,
            pageSize: pageSize,
            trialId: trialId,
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

