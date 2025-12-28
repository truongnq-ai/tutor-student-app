import 'package:equatable/equatable.dart';

class MiniTestSessionEntity extends Equatable {
  final String sessionId;
  final String? chapterId;
  final String? chapterName;
  final String? skillId;  // Kept for backward compatibility
  final String? skillCode;
  final String? skillName;
  final String status; // "IN_PROGRESS", "SUBMITTED", "EXPIRED"
  final DateTime startedAt;
  final int timeLimitSec;
  final int timeRemainingSec;
  final int totalQuestions;
  final int currentQuestionIndex;
  final Map<int, String> answers; // Question index -> Answer

  const MiniTestSessionEntity({
    required this.sessionId,
    this.chapterId,
    this.chapterName,
    this.skillId,
    this.skillCode,
    this.skillName,
    required this.status,
    required this.startedAt,
    required this.timeLimitSec,
    required this.timeRemainingSec,
    required this.totalQuestions,
    required this.currentQuestionIndex,
    required this.answers,
  });

  @override
  List<Object?> get props => [
        sessionId,
        chapterId,
        chapterName,
        skillId,
        skillCode,
        skillName,
        status,
        startedAt,
        timeLimitSec,
        timeRemainingSec,
        totalQuestions,
        currentQuestionIndex,
        answers,
      ];
}

