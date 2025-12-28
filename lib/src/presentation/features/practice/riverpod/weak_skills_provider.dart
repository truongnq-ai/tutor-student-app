import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/weak_skill_entity.dart';

part 'weak_skills_provider.g.dart';

@riverpod
class WeakSkills extends _$WeakSkills {
  static const int _pageSize = 10;

  @override
  Future<List<WeakSkillEntity>> build() async {
    return _fetchWeakSkills(offset: 0);
  }

  Future<List<WeakSkillEntity>> _fetchWeakSkills({
    required int offset,
    int limit = _pageSize,
  }) async {
    final response = await ref.read(learningRepositoryProvider).getWeakSkills(
      limit: limit,
      offset: offset,
    );
    if (response.isSuccess && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.getErrorMessage());
    }
  }

  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final newSkills = await _fetchWeakSkills(offset: currentState.length);
    if (newSkills.isEmpty) return; // No more skills to load

    state = AsyncValue.data([...currentState, ...newSkills]);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchWeakSkills(offset: 0));
  }
}

