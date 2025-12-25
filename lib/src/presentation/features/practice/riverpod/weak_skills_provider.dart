import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/weak_skill_entity.dart';

part 'weak_skills_provider.g.dart';

@riverpod
class WeakSkills extends _$WeakSkills {
  @override
  Future<List<WeakSkillEntity>> build() async {
    return _fetchWeakSkills();
  }

  Future<List<WeakSkillEntity>> _fetchWeakSkills() async {
    final response = await ref.read(learningRepositoryProvider).getWeakSkills();
    if (response.isSuccess && response.data != null) {
      return response.data!;
    } else {
      throw Exception(response.getErrorMessage());
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchWeakSkills());
  }
}

