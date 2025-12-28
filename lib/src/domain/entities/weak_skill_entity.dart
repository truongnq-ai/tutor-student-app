import 'package:equatable/equatable.dart';

class WeakSkillEntity extends Equatable {
  final String skillId;
  final String skillCode;
  final String skillName;
  final String? chapterId;
  final String? chapterName;
  final String? description;
  final int masteryLevel;
  final String status; // "weak" (< 40), "needs_practice" (40-69)
  final int questionCount;
  final int estimatedTimeMinutes;
  final bool isPriority;

  const WeakSkillEntity({
    required this.skillId,
    required this.skillCode,
    required this.skillName,
    this.chapterId,
    this.chapterName,
    this.description,
    required this.masteryLevel,
    required this.status,
    required this.questionCount,
    required this.estimatedTimeMinutes,
    required this.isPriority,
  });

  @override
  List<Object?> get props => [
        skillId,
        skillCode,
        skillName,
        chapterId,
        chapterName,
        description,
        masteryLevel,
        status,
        questionCount,
        estimatedTimeMinutes,
        isPriority,
      ];
}

