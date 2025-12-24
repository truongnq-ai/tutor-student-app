import '../../core/base/response_object.dart';
import '../../core/constants/error_codes.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../services/cache/cache_service.dart';
import '../services/network/services/student_service.dart';

final class OnboardingRepositoryImpl extends OnboardingRepository {
  OnboardingRepositoryImpl({
    required this.studentService,
    required this.cacheService,
  });

  final StudentService studentService;
  final CacheService cacheService;

  /// Get trialId or anonymousId for API calls
  Future<Map<String, String?>> _getTrialIdentifiers() async {
    final trialId = cacheService.get<String>(CacheKey.trialId);
    final anonymousId = cacheService.get<String>(CacheKey.anonymousId);
    return {
      'trialId': trialId,
      'anonymousId': anonymousId,
    };
  }

  @override
  Future<ResponseObject<void>> saveGrade(int grade) async {
    try {
      final identifiers = await _getTrialIdentifiers();
      
      // Build request body
      final request = <String, dynamic>{
        'grade': grade,
      };

      final response = await studentService.saveGrade(
        identifiers['trialId'],
        identifiers['anonymousId'],
        request,
      );

      // Parse ResponseObject from HttpResponse
      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: ErrorCodes.internalError,
          errorDetail: 'Invalid response format',
        );
      }

      // Ensure responseJson is a Map
      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      // Parse ResponseObject from JSON
      final responseData = ResponseObject<dynamic>.fromJson(
        responseMap,
        (data) => data,
      );

      // Check if response is successful
      if (!responseData.isSuccess) {
        final errorCode = responseData.errorCode ?? ErrorCodes.internalError;
        if (errorCode == ErrorCodes.gradeInvalid) {
          return ResponseObject.error(
            errorCode: errorCode,
            errorDetail: responseData.errorDetail ?? 'Invalid grade',
          );
        }
        if (errorCode == ErrorCodes.missingRequestParameter) {
          return ResponseObject.error(
            errorCode: errorCode,
            errorDetail: responseData.errorDetail ?? 'Missing required parameter',
          );
        }
        return ResponseObject.error(
          errorCode: errorCode,
          errorDetail: responseData.errorDetail ?? 'Failed to save grade',
        );
      }

      // Save to cache on success
      await cacheService.save(CacheKey.grade, grade);

      return ResponseObject.success(null);
    } catch (e) {
      return ResponseObject.error(
        errorCode: ErrorCodes.internalError,
        errorDetail: 'Failed to save grade: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<int?>> getGrade() async {
    try {
      // Try cache first
      final cachedGrade = cacheService.get<int>(CacheKey.grade);
      if (cachedGrade != null) {
        return ResponseObject.success(cachedGrade);
      }

      // Get from API
      final identifiers = await _getTrialIdentifiers();

      final response = await studentService.getGrade(
        identifiers['trialId'],
        identifiers['anonymousId'],
      );

      // Parse ResponseObject from HttpResponse
      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.success(null);
      }

      // Ensure responseJson is a Map
      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      // Parse ResponseObject from JSON
      final responseData = ResponseObject<dynamic>.fromJson(
        responseMap,
        (data) => data,
      );

      // Check if response is successful
      if (!responseData.isSuccess) {
        // If not found, return null (not an error)
        if (responseData.errorCode == ErrorCodes.trialNotFound) {
          return ResponseObject.success(null);
        }
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? ErrorCodes.internalError,
          errorDetail: responseData.errorDetail ?? 'Failed to get grade',
        );
      }

      // Parse grade from data
      final gradeData = responseData.data;
      int? grade;
      if (gradeData is int) {
        grade = gradeData;
      } else if (gradeData is Map<String, dynamic>) {
        grade = gradeData['grade'] as int?;
      }

      // Save to cache if found
      if (grade != null) {
        await cacheService.save(CacheKey.grade, grade);
      }

      return ResponseObject.success(grade);
    } catch (e) {
      // On error, return cached value if available
      final cachedGrade = cacheService.get<int>(CacheKey.grade);
      return ResponseObject.success(cachedGrade);
    }
  }

  @override
  Future<ResponseObject<void>> saveLearningGoals(Set<String> goals) async {
    try {
      final identifiers = await _getTrialIdentifiers();
      
      // Build request body
      final request = <String, dynamic>{
        'goals': goals.toList(),
      };

      final response = await studentService.saveLearningGoals(
        identifiers['trialId'],
        identifiers['anonymousId'],
        request,
      );

      // Parse ResponseObject from HttpResponse
      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.error(
          errorCode: ErrorCodes.internalError,
          errorDetail: 'Invalid response format',
        );
      }

      // Ensure responseJson is a Map
      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      // Parse ResponseObject from JSON
      final responseData = ResponseObject<dynamic>.fromJson(
        responseMap,
        (data) => data,
      );

      // Check if response is successful
      if (!responseData.isSuccess) {
        final errorCode = responseData.errorCode ?? ErrorCodes.internalError;
        if (errorCode == ErrorCodes.learningGoalsEmpty) {
          return ResponseObject.error(
            errorCode: errorCode,
            errorDetail: responseData.errorDetail ?? 'Learning goals cannot be empty',
          );
        }
        if (errorCode == ErrorCodes.missingRequestParameter) {
          return ResponseObject.error(
            errorCode: errorCode,
            errorDetail: responseData.errorDetail ?? 'Missing required parameter',
          );
        }
        return ResponseObject.error(
          errorCode: errorCode,
          errorDetail: responseData.errorDetail ?? 'Failed to save learning goals',
        );
      }

      // Save to cache on success
      await cacheService.save(CacheKey.learningGoals, goals.toList());

      return ResponseObject.success(null);
    } catch (e) {
      return ResponseObject.error(
        errorCode: ErrorCodes.internalError,
        errorDetail: 'Failed to save learning goals: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<Set<String>>> getLearningGoals() async {
    try {
      // Try cache first
      final cachedGoalsList = cacheService.get<List<dynamic>>(CacheKey.learningGoals);
      if (cachedGoalsList != null) {
        final goals = cachedGoalsList.map((e) => e.toString()).toSet();
        return ResponseObject.success(goals);
      }

      // Get from API
      final identifiers = await _getTrialIdentifiers();

      final response = await studentService.getLearningGoals(
        identifiers['trialId'],
        identifiers['anonymousId'],
      );

      // Parse ResponseObject from HttpResponse
      final responseJson = response.data;
      if (responseJson == null) {
        return ResponseObject.success(<String>{});
      }

      // Ensure responseJson is a Map
      final responseMap = responseJson is Map<String, dynamic>
          ? responseJson
          : <String, dynamic>{};

      // Parse ResponseObject from JSON
      final responseData = ResponseObject<dynamic>.fromJson(
        responseMap,
        (data) => data,
      );

      // Check if response is successful
      if (!responseData.isSuccess) {
        // If not found, return empty set (not an error)
        if (responseData.errorCode == ErrorCodes.trialNotFound) {
          return ResponseObject.success(<String>{});
        }
        return ResponseObject.error(
          errorCode: responseData.errorCode ?? ErrorCodes.internalError,
          errorDetail: responseData.errorDetail ?? 'Failed to get learning goals',
        );
      }

      // Parse learning goals from data
      final goalsData = responseData.data;
      Set<String> goals = <String>{};
      if (goalsData is List) {
        goals = goalsData.map((e) => e.toString()).toSet();
      } else if (goalsData is Map<String, dynamic>) {
        final goalsList = goalsData['goals'] as List?;
        if (goalsList != null) {
          goals = goalsList.map((e) => e.toString()).toSet();
        }
      }

      // Save to cache if found
      if (goals.isNotEmpty) {
        await cacheService.save(CacheKey.learningGoals, goals.toList());
      }

      return ResponseObject.success(goals);
    } catch (e) {
      // On error, return cached value if available
      final cachedGoalsList = cacheService.get<List<dynamic>>(CacheKey.learningGoals);
      if (cachedGoalsList != null) {
        final goals = cachedGoalsList.map((e) => e.toString()).toSet();
        return ResponseObject.success(goals);
      }
      return ResponseObject.success(<String>{});
    }
  }
}

