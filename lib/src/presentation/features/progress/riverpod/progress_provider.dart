import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/progress_dashboard_entity.dart';
import '../../../../domain/entities/skill_detail_entity.dart';
import '../../../../domain/entities/recommendation_entity.dart';
import '../../../../domain/entities/weak_skill_entity.dart';

part 'progress_provider.g.dart';

@riverpod
class ProgressDashboard extends _$ProgressDashboard {
  @override
  Future<ProgressDashboardEntity?> build() async {
    return null;
  }

  Future<void> loadDashboard({String? trialId}) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(progressRepositoryProvider).getProgressDashboard(
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

  void reset() {
    state = const AsyncValue.data(null);
  }
}

@riverpod
class SkillDetail extends _$SkillDetail {
  @override
  Future<SkillDetailEntity?> build(String skillId) async {
    return null;
  }

  Future<void> loadSkillDetail({
    required String skillId,
    String? trialId,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(progressRepositoryProvider).getSkillDetail(
            skillId: skillId,
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

  void reset() {
    state = const AsyncValue.data(null);
  }
}

@riverpod
class WeakSkills extends _$WeakSkills {
  @override
  Future<List<WeakSkillEntity>> build({int limit = 5}) async {
    return _fetchWeakSkills(limit: limit);
  }

  Future<List<WeakSkillEntity>> _fetchWeakSkills({int limit = 5}) async {
    final response = await ref.read(progressRepositoryProvider).getWeakSkills(
          limit: limit,
        );
    if (response.isSuccess && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.getErrorMessage());
    }
  }

  Future<void> refresh({int limit = 5}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchWeakSkills(limit: limit));
  }
}

@riverpod
class Recommendations extends _$Recommendations {
  @override
  Future<RecommendationEntity?> build() async {
    return null;
  }

  Future<void> loadRecommendations({String? trialId}) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(progressRepositoryProvider).getRecommendations(
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

  void reset() {
    state = const AsyncValue.data(null);
  }
}

