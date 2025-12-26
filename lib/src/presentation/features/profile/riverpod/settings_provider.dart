import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/settings_entity.dart';

part 'settings_provider.g.dart';

@riverpod
class Settings extends _$Settings {
  @override
  Future<SettingsEntity?> build() async {
    return null;
  }

  Future<void> loadSettings() async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(settingsRepositoryProvider).getSettings();

      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
      } else {
        final errorMessage = response.getErrorMessage();
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateSettings({
    bool? notificationPush,
    bool? notificationLearningReminder,
    bool? notificationProgress,
    bool? showDetailedStats,
    String? practiceMode,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      final response = await ref.read(settingsRepositoryProvider).updateSettings(
            notificationPush: notificationPush,
            notificationLearningReminder: notificationLearningReminder,
            notificationProgress: notificationProgress,
            showDetailedStats: showDetailedStats,
            practiceMode: practiceMode,
          );

      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data);
      } else {
        final errorMessage = response.getErrorMessage();
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

