import 'package:equatable/equatable.dart';

class PracticeSessionEntity extends Equatable {
  final String sessionId;
  final String skillId;
  final String skillCode;
  final String skillName;
  final String status; // "IN_PROGRESS", "PAUSED", "COMPLETED", "EXPIRED"
  final DateTime startedAt;
  final DateTime? pausedAt;
  final DateTime? completedAt;
  final int totalQuestions;
  final int currentQuestionIndex;
  final int completedQuestions;

  const PracticeSessionEntity({
    required this.sessionId,
    required this.skillId,
    required this.skillCode,
    required this.skillName,
    required this.status,
    required this.startedAt,
    this.pausedAt,
    this.completedAt,
    required this.totalQuestions,
    required this.currentQuestionIndex,
    required this.completedQuestions,
  });

  @override
  List<Object?> get props => [
        sessionId,
        skillId,
        skillCode,
        skillName,
        status,
        startedAt,
        pausedAt,
        completedAt,
        totalQuestions,
        currentQuestionIndex,
        completedQuestions,
      ];
}

