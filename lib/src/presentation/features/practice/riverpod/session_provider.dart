import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/session_info_entity.dart';

part 'session_provider.g.dart';

@riverpod
class SessionInfo extends _$SessionInfo {
  @override
  Future<SessionInfoEntity?> build({required String sessionId}) async {
    return _fetchSessionInfo(sessionId);
  }

  Future<SessionInfoEntity?> _fetchSessionInfo(String sessionId) async {
    final response = await ref.read(practiceRepositoryProvider).getSessionInfo(sessionId);
    if (response.isSuccess && response.data != null) {
      return response.data;
    } else {
      throw Exception(response.getErrorMessage());
    }
  }

  Future<void> refresh() async {
    final sessionId = state.value?.sessionId ?? '';
    if (sessionId.isEmpty) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchSessionInfo(sessionId));
  }
}

