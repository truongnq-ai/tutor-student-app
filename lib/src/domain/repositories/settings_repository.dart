import '../../core/base/response_object.dart';
import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<ResponseObject<SettingsEntity>> getSettings();
  
  Future<ResponseObject<SettingsEntity>> updateSettings({
    bool? notificationPush,
    bool? notificationLearningReminder,
    bool? notificationProgress,
    bool? showDetailedStats,
    String? practiceMode,
  });
}

