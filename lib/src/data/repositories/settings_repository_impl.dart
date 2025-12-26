import '../../core/base/response_object.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../models/settings_model.dart';
import '../services/network/services/settings_service.dart';

final class SettingsRepositoryImpl extends SettingsRepository {
  SettingsRepositoryImpl({
    required this.settingsService,
  });

  final SettingsService settingsService;

  @override
  Future<ResponseObject<SettingsEntity>> getSettings() async {
    try {
      final response = await settingsService.getSettings();

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to get settings',
        );
      }

      final settingsData = responseData.data;
      if (settingsData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final settings = SettingsModel.fromJson(settingsData);
      return ResponseObject.success(settings);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get settings: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<SettingsEntity>> updateSettings({
    bool? notificationPush,
    bool? notificationLearningReminder,
    bool? notificationProgress,
    bool? showDetailedStats,
    String? practiceMode,
  }) async {
    try {
      final requestBody = <String, dynamic>{};
      if (notificationPush != null) {
        requestBody['notificationPush'] = notificationPush;
      }
      if (notificationLearningReminder != null) {
        requestBody['notificationLearningReminder'] = notificationLearningReminder;
      }
      if (notificationProgress != null) {
        requestBody['notificationProgress'] = notificationProgress;
      }
      if (showDetailedStats != null) {
        requestBody['showDetailedStats'] = showDetailedStats;
      }
      if (practiceMode != null) {
        requestBody['practiceMode'] = practiceMode;
      }

      final response = await settingsService.updateSettings(requestBody);

      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'Invalid response format',
        );
      }

      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      final responseData = ResponseObject<Map<String, dynamic>>.fromJson(
        responseMap,
        (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      if (!responseData.isSuccess) {
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? '5001',
          errorDetail: responseData.errorDetail ?? 'Failed to update settings',
        );
      }

      final settingsData = responseData.data;
      if (settingsData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final settings = SettingsModel.fromJson(settingsData);
      return ResponseObject.success(settings);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to update settings: ${e.toString()}',
      );
    }
  }
}

