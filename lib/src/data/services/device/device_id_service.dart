import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';

import '../cache/cache_service.dart';

/// Service for getting stable device identifier.
/// 
/// Uses:
/// - Android: ANDROID_ID (Settings.Secure)
/// - iOS: identifierForVendor (IDFV)
/// - Fallback: Firebase Installation ID (when platform-specific methods fail)
class DeviceIdService {
  DeviceIdService({
    required this.cacheService,
  });

  final CacheService cacheService;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Get stable device ID.
  /// 
  /// Returns cached value if available, otherwise fetches from device
  /// and caches it for future use.
  Future<String> getDeviceId() async {
    // Check cache first
    final cachedId = cacheService.get<String>(CacheKey.deviceId);
    if (cachedId != null && cachedId.isNotEmpty) {
      return cachedId;
    }

    // Get device ID from platform
    String deviceId;
    try {
      if (Platform.isAndroid) {
        deviceId = await _getAndroidId();
      } else if (Platform.isIOS) {
        deviceId = await _getIosIdfv();
      } else {
        // Fallback for other platforms: use Firebase Installation ID
        deviceId = await _getFirebaseInstallationId();
      }
    } catch (e) {
      // If platform-specific method fails, use Firebase Installation ID
      deviceId = await _getFirebaseInstallationId();
    }

    // Cache the device ID
    await cacheService.save(CacheKey.deviceId, deviceId);

    return deviceId;
  }

  /// Get Android ID (Settings.Secure.ANDROID_ID)
  Future<String> _getAndroidId() async {
    final androidInfo = await _deviceInfo.androidInfo;
    final androidId = androidInfo.id;

    if (androidId.isEmpty || androidId == '9774d56d682e549c') {
      // Invalid or default Android ID, use Firebase Installation ID
      return _getFirebaseInstallationId();
    }

    return androidId;
  }

  /// Get iOS identifierForVendor (IDFV)
  Future<String> _getIosIdfv() async {
    final iosInfo = await _deviceInfo.iosInfo;
    final idfv = iosInfo.identifierForVendor;

    if (idfv == null || idfv.isEmpty) {
      // IDFV not available, use Firebase Installation ID
      return _getFirebaseInstallationId();
    }

    return idfv;
  }

  /// Get Firebase Installation ID as fallback
  Future<String> _getFirebaseInstallationId() async {
    try {
      final installations = FirebaseInstallations.instance;
      final id = await installations.getId();
      return id;
    } catch (e) {
      // If Firebase Installation ID also fails, throw exception
      // This should be handled by the caller
      throw Exception('Failed to get Firebase Installation ID: $e');
    }
  }

  /// Get device platform (ANDROID, IOS, WEB)
  String getPlatform() {
    if (Platform.isAndroid) {
      return 'ANDROID';
    } else if (Platform.isIOS) {
      return 'IOS';
    } else {
      return 'WEB';
    }
  }

  /// Get device model
  Future<String?> getModel() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.model;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get OS version
  Future<String?> getOSVersion() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.version.release;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.systemVersion;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

