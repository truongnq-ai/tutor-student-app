import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'learning_goal_provider.g.dart';

@riverpod
class LearningGoals extends _$LearningGoals {
  @override
  AsyncValue<Set<String>> build() {
    // Mock: Get from local storage or return empty set
    // In real implementation, this would read from cache/local storage
    return const AsyncValue.data({});
  }

  Future<void> saveLearningGoals(Set<String> goals) async {
    if (state.isLoading) return;

    state = const AsyncValue<Set<String>>.loading();

    try {
      // Mock: Save learning goals (local storage)
      // In real implementation, this would call the API and save to local storage
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Validate: minimum 1 selection required
      if (goals.isEmpty) {
        throw Exception('Vui lòng chọn ít nhất một mục tiêu học tập.');
      }

      state = AsyncValue<Set<String>>.data(goals);
    } catch (e, stackTrace) {
      state = AsyncValue<Set<String>>.error(e, stackTrace);
    }
  }

  Set<String> getSelectedGoals() {
    return state.value ?? {};
  }
}

