import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../localization_provider/localization_provider.dart';

part 'app_startup_provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(Ref ref) async {
  ref.onDispose(() {
    ref.invalidate(sharedPreferencesProvider);
  });

  await ref.watch(sharedPreferencesProvider.future);

  // Initialize Firebase (required for Firebase Installations)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Firebase might already be initialized, ignore error
  }

  await ref.read(localizationProvider.notifier).setCurrentLocal();
  
  // Initialize deviceId and anonymousId if not exists
  final cacheService = ref.read(cacheServiceProvider);
  final deviceIdService = ref.read(deviceIdServiceProvider);
  
  // Get stable deviceId using DeviceIdService (ANDROID_ID/IDFV + Firebase Installation ID fallback)
  String? deviceId = cacheService.get<String>(CacheKey.deviceId);
  if (deviceId == null) {
    deviceId = await deviceIdService.getDeviceId();
    await cacheService.save(CacheKey.deviceId, deviceId);
  }
  
  // Generate anonymousId if not exists (keep as UUID v4 for analytics)
  var anonymousId = cacheService.get<String>(CacheKey.anonymousId);
  if (anonymousId == null) {
    anonymousId = const Uuid().v4();
    await cacheService.save(CacheKey.anonymousId, anonymousId);
  }
}
