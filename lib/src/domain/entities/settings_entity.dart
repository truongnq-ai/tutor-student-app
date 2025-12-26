import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final bool notificationPush;
  final bool notificationLearningReminder;
  final bool notificationProgress;
  final bool showDetailedStats;
  final String practiceMode; // "auto" or "manual"

  const SettingsEntity({
    required this.notificationPush,
    required this.notificationLearningReminder,
    required this.notificationProgress,
    required this.showDetailedStats,
    required this.practiceMode,
  });

  @override
  List<Object?> get props => [
        notificationPush,
        notificationLearningReminder,
        notificationProgress,
        showDetailedStats,
        practiceMode,
      ];
}

