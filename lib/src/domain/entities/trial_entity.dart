enum TrialStatus {
  active,
  expired,
  consumed;

  static TrialStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'ACTIVE':
        return TrialStatus.active;
      case 'EXPIRED':
        return TrialStatus.expired;
      case 'CONSUMED':
        return TrialStatus.consumed;
      default:
        return TrialStatus.active;
    }
  }

  String toUpperCaseString() {
    switch (this) {
      case TrialStatus.active:
        return 'ACTIVE';
      case TrialStatus.expired:
        return 'EXPIRED';
      case TrialStatus.consumed:
        return 'CONSUMED';
    }
  }
}

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
  final TrialStatus? trialStatus;

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
    this.trialStatus,
  });
}

