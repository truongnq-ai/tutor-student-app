import 'package:dio/dio.dart';

/// Base REST client (kept for backward compatibility)
/// 
/// Note: New code should use specific service interfaces:
/// - StudentService
/// - TutorService
/// - LearningService
/// - PracticeService
/// - MiniTestService
/// - LinkingService
/// - AuthService
class RestClient {
  final Dio dio;
  final String? baseUrl;

  RestClient(this.dio, {this.baseUrl});
}
