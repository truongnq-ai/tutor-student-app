class TrialEntity {
  final String? trialId;
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

  TrialEntity({
    this.trialId,
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
}

