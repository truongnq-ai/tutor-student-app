import '../../core/base/response_object.dart';
import '../../domain/entities/tutor_entity.dart';
import '../../domain/repositories/tutor_repository.dart';
import '../models/tutor_model.dart';
import '../services/network/services/tutor_service.dart';

final class TutorRepositoryImpl extends TutorRepository {
  TutorRepositoryImpl({
    required this.tutorService,
  });

  final TutorService tutorService;

  @override
  Future<ResponseObject<SolveResponseEntity>> solveFromImage({
    required String imageUrl,
    required int grade,
    String? trialId,
  }) async {
    try {
      final response = await tutorService.solveImage(
        {
          'imageUrl': imageUrl,
          'grade': grade,
        },
        trialId,
      );

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
          errorDetail: responseData.errorDetail ?? 'Failed to solve problem',
        );
      }

      final solveData = responseData.data;
      if (solveData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final solveResponse = SolveResponseModel.fromJson(solveData);
      return ResponseObject.success(solveResponse);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to solve problem: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<SolveResponseEntity>> solveFromText({
    required String problemText,
    required int grade,
    String? trialId,
  }) async {
    try {
      final response = await tutorService.solveText(
        {
          'problemText': problemText,
          'grade': grade,
        },
        trialId,
      );

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
          errorDetail: responseData.errorDetail ?? 'Failed to solve problem',
        );
      }

      final solveData = responseData.data;
      if (solveData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final solveResponse = SolveResponseModel.fromJson(solveData);
      return ResponseObject.success(solveResponse);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to solve problem: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<Map<String, dynamic>>> getRecentProblems({
    int page = 0,
    int pageSize = 10,
    String? trialId,
  }) async {
    try {
      final response = await tutorService.getRecentProblems(
        page,
        pageSize,
        trialId,
      );

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
          errorDetail: responseData.errorDetail ?? 'Failed to get recent problems',
        );
      }

      // Spring Boot Page response format:
      // {
      //   "content": [...],
      //   "totalElements": 10,
      //   "totalPages": 1,
      //   "number": 0,
      //   "size": 10,
      //   ...
      // }
      final pageData = responseData.data;
      if (pageData == null) {
        return ResponseObject.success(<String, dynamic>{
          'content': <dynamic>[],
          'totalElements': 0,
          'totalPages': 0,
          'number': 0,
          'size': pageSize,
        });
      }

      // Ensure content is a list
      final pageMap = pageData;
      if (pageMap['content'] == null) {
        pageMap['content'] = <dynamic>[];
      }

      return ResponseObject.success(pageMap);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get recent problems: ${e.toString()}',
      );
    }
  }
}

