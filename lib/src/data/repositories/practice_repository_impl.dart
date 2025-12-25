import '../../core/base/response_object.dart';
import '../../domain/entities/practice_entity.dart';
import '../../domain/entities/session_info_entity.dart';
import '../../domain/repositories/practice_repository.dart';
import '../models/practice_model.dart';
import '../models/session_info_model.dart';
import '../services/network/services/practice_service.dart';

final class PracticeRepositoryImpl extends PracticeRepository {
  PracticeRepositoryImpl({
    required this.practiceService,
  });

  final PracticeService practiceService;

  @override
  Future<ResponseObject<PracticeResponseEntity>> submitPractice({
    required String skillId,
    required String answer,
    int? durationSec,
    String? questionId,
  }) async {
    try {
      final response = await practiceService.submitPractice(
        skillId,
        answer,
        durationSec,
        questionId,
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
          errorDetail: responseData.errorDetail ?? 'Failed to submit practice',
        );
      }

      final practiceData = responseData.data;
      if (practiceData == null) {
        return ResponseObject.error(
          errorCode: '5001',
          errorDetail: 'No data in response',
        );
      }

      final practice = PracticeResponseModel.fromJson(practiceData);
      return ResponseObject.success(practice);
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to submit practice: ${e.toString()}',
      );
    }
  }

  @override
  Future<ResponseObject<Map<String, dynamic>>> getPracticeHistory({
    int page = 0,
    int pageSize = 20,
    String? skillId,
  }) async {
    try {
      final response = await practiceService.getPracticeHistory(
        page: page,
        pageSize: pageSize,
        skillId: skillId,
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
          errorDetail: responseData.errorDetail ?? 'Failed to get practice history',
        );
      }

      return ResponseObject.success(responseData.data ?? <String, dynamic>{});
    } catch (e) {
      return ResponseObject.error(
        errorCode: '5001',
        errorDetail: 'Failed to get practice history: ${e.toString()}',
      );
    }
  }
}

