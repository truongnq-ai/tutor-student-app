part of '../dependency_injection.dart';

import '../../data/services/network/endpoints.dart';
import '../../data/services/network/services/auth_service.dart';
import '../../data/services/network/services/learning_service.dart';
import '../../data/services/network/services/linking_service.dart';
import '../../data/services/network/services/mini_test_service.dart';
import '../../data/services/network/services/practice_service.dart';
import '../../data/services/network/services/student_service.dart';
import '../../data/services/network/services/tutor_service.dart';

@Riverpod(keepAlive: true)
CacheService cacheService(Ref ref) {
  return SharedPreferencesService(
    ref.read(sharedPreferencesProvider).requireValue,
  );
}

@riverpod
RestClient restClientService(Ref ref) {
  return RestClient(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
StudentService studentService(Ref ref) {
  return StudentService(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
TutorService tutorService(Ref ref) {
  return TutorService(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
LearningService learningService(Ref ref) {
  return LearningService(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
PracticeService practiceService(Ref ref) {
  return PracticeService(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
MiniTestService miniTestService(Ref ref) {
  return MiniTestService(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
LinkingService linkingService(Ref ref) {
  return LinkingService(ref.read(dioProvider), baseUrl: Endpoints.base);
}

@riverpod
AuthService authService(Ref ref) {
  return AuthService(ref.read(dioProvider), baseUrl: Endpoints.base);
}
