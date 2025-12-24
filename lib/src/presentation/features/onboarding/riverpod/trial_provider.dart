import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trial_provider.g.dart';

// Mock trial status model
class TrialStatus {
  final int daysRemaining;
  final int daysUsed;
  final int totalDays;
  final DateTime startDate;
  final DateTime endDate;
  final int solvesToday;
  final int maxSolvesPerDay;
  final int totalExercises;
  final int skillsLearned;
  final bool isLinked;

  TrialStatus({
    required this.daysRemaining,
    required this.daysUsed,
    required this.totalDays,
    required this.startDate,
    required this.endDate,
    required this.solvesToday,
    required this.maxSolvesPerDay,
    required this.totalExercises,
    required this.skillsLearned,
    required this.isLinked,
  });

  String get statusBadge {
    if (daysRemaining >= 3) {
      return 'Đang dùng thử';
    } else if (daysRemaining >= 1) {
      return 'Sắp hết hạn';
    } else {
      return 'Đã hết hạn';
    }
  }
}

@riverpod
class Trial extends _$Trial {
  @override
  AsyncValue<TrialStatus?> build() {
    // Mock: Return null initially (no trial)
    return const AsyncValue.data(null);
  }

  Future<void> startTrial() async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      // Mock: Create trial profile
      // In real implementation, this would call the API
      await Future<void>.delayed(const Duration(seconds: 1));

      final now = DateTime.now();
      final endDate = now.add(const Duration(days: 7));

      final trialStatus = TrialStatus(
        daysRemaining: 7,
        daysUsed: 0,
        totalDays: 7,
        startDate: now,
        endDate: endDate,
        solvesToday: 0,
        maxSolvesPerDay: 5,
        totalExercises: 0,
        skillsLearned: 0,
        isLinked: false,
      );

      state = AsyncValue.data(trialStatus);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<TrialStatus?> getTrialStatus() async {
    // Mock: Get trial status
    // In real implementation, this would call the API
    if (state.value != null) {
      return state.value;
    }

    // Mock: Return sample trial status
    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 5));

    return TrialStatus(
      daysRemaining: 5,
      daysUsed: 2,
      totalDays: 7,
      startDate: now.subtract(const Duration(days: 2)),
      endDate: endDate,
      solvesToday: 3,
      maxSolvesPerDay: 5,
      totalExercises: 45,
      skillsLearned: 8,
      isLinked: false,
    );
  }
}

