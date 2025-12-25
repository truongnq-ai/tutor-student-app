import 'package:equatable/equatable.dart';

class SessionInfoEntity extends Equatable {
  final String sessionId;
  final String skillId;
  final String? skillName;
  final String? skillCode;
  final int totalQuestions;
  final int completedQuestions;
  final int currentQuestionIndex; // 0-based index of next question
  final int? currentMastery;
  final DateTime? startedAt;
  final DateTime? lastActivityAt;

  const SessionInfoEntity({
    required this.sessionId,
    required this.skillId,
    this.skillName,
    this.skillCode,
    required this.totalQuestions,
    required this.completedQuestions,
    required this.currentQuestionIndex,
    this.currentMastery,
    this.startedAt,
    this.lastActivityAt,
  });

  @override
  List<Object?> get props => [
        sessionId,
        skillId,
        skillName,
        skillCode,
        totalQuestions,
        completedQuestions,
        currentQuestionIndex,
        currentMastery,
        startedAt,
        lastActivityAt,
      ];
}

