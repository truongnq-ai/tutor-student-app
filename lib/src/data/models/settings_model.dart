import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/settings_entity.dart';

part 'settings_model.mapper.dart';

@MappableClass()
class SettingsModel extends SettingsEntity with SettingsModelMappable {
  const SettingsModel({
    required super.notificationPush,
    required super.notificationLearningReminder,
    required super.notificationProgress,
    required super.showDetailedStats,
    required super.practiceMode,
  });

  static const fromJson = SettingsModelMapper.fromJson;
}

