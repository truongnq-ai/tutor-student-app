import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';

part 'session_management_provider.g.dart';

/// Provider to manage current practice session ID
@riverpod
class SessionManagement extends _$SessionManagement {
  @override
  Future<String?> build() async {
    // Load from cache if exists
    return _loadCurrentSessionId();
  }

  Future<String?> _loadCurrentSessionId() async {
    final cacheService = ref.read(cacheServiceProvider);
    return await cacheService.get('current_session_id');
  }

  /// Set current session ID
  Future<void> setCurrentSessionId(String sessionId) async {
    final cacheService = ref.read(cacheServiceProvider);
    await cacheService.set('current_session_id', sessionId);
    state = AsyncValue.data(sessionId);
  }

  /// Clear current session ID
  Future<void> clearCurrentSessionId() async {
    final cacheService = ref.read(cacheServiceProvider);
    await cacheService.remove('current_session_id');
    state = const AsyncValue.data(null);
  }

  /// Get current session ID
  String? getCurrentSessionId() {
    return state.value;
  }
}

