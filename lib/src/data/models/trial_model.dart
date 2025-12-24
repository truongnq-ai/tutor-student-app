import '../../../domain/entities/trial_entity.dart';

class TrialModel extends TrialEntity {
  TrialModel({
    super.trialId,
    required super.daysRemaining,
    required super.daysUsed,
    required super.totalDays,
    required super.startDate,
    required super.endDate,
    required super.solvesToday,
    required super.maxSolvesPerDay,
    required super.totalExercises,
    required super.skillsLearned,
    required super.isLinked,
  });

  factory TrialModel.fromJson(Map<String, dynamic> json) {
    return TrialModel(
      trialId: json['trialId'] as String?,
      daysRemaining: json['daysRemaining'] as int,
      daysUsed: json['daysUsed'] as int,
      totalDays: json['totalDays'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      solvesToday: json['solvesToday'] as int,
      maxSolvesPerDay: json['maxSolvesPerDay'] as int,
      totalExercises: json['totalExercises'] as int,
      skillsLearned: json['skillsLearned'] as int,
      isLinked: json['isLinked'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (trialId != null) 'trialId': trialId,
      'daysRemaining': daysRemaining,
      'daysUsed': daysUsed,
      'totalDays': totalDays,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'solvesToday': solvesToday,
      'maxSolvesPerDay': maxSolvesPerDay,
      'totalExercises': totalExercises,
      'skillsLearned': skillsLearned,
      'isLinked': isLinked,
    };
  }
}

