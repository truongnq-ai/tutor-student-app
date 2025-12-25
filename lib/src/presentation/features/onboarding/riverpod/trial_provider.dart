import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/failure.dart';
import '../../../../core/constants/error_codes.dart';
import '../../../../core/di/parts/repository.dart';
import '../../../../domain/repositories/trial_repository.dart';

part 'trial_provider.g.dart';

// Trial status model
class TrialStatus {
  final int daysRemaining;
  final int daysUsed;
  final int totalDays;
  final DateTime startDate;
  final DateTime endDate;
  final int solvesToday;
  final int maxSolvesPerDay;
  final int totalExercises;
  final int skillsLearned;
  final bool isLinked;

  TrialStatus({
    required this.daysRemaining,
    required this.daysUsed,
    required this.totalDays,
    required this.startDate,
    required this.endDate,
    required this.solvesToday,
    required this.maxSolvesPerDay,
    required this.totalExercises,
    required this.skillsLearned,
    required this.isLinked,
  });

  String get statusBadge {
    if (daysRemaining >= 3) {
      return 'Đang dùng thử';
    } else if (daysRemaining >= 1) {
      return 'Sắp hết hạn';
    } else {
      return 'Đã hết hạn';
    }
  }

  factory TrialStatus.fromEntity(dynamic entity) {
    return TrialStatus(
      daysRemaining: entity.daysRemaining,
      daysUsed: entity.daysUsed,
      totalDays: entity.totalDays,
      startDate: entity.startDate,
      endDate: entity.endDate,
      solvesToday: entity.solvesToday,
      maxSolvesPerDay: entity.maxSolvesPerDay,
      totalExercises: entity.totalExercises,
      skillsLearned: entity.skillsLearned,
      isLinked: entity.isLinked,
    );
  }
}

@riverpod
class Trial extends _$Trial {
  @override
  AsyncValue<TrialStatus?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> startTrial() async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      final repository = ref.read(trialRepositoryProvider);
      
      // Add timeout (10 seconds)
      final response = await repository.startTrial().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException(
            'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.',
            const Duration(seconds: 10),
          );
        },
      );

      if (!response.isSuccess) {
        final errorCode = response.errorCode ?? ErrorCodes.internalError;
        String errorMessage = response.errorDetail ?? 'Không thể bắt đầu trial. Vui lòng thử lại.';
        
        // Handle specific error codes
        if (errorCode == ErrorCodes.trialNotFound) {
          errorMessage = 'Không tìm thấy trial. Vui lòng thử lại.';
        } else if (errorCode == ErrorCodes.trialExpired) {
          errorMessage = 'Trial đã hết hạn.';
        } else if (errorCode == ErrorCodes.missingRequestParameter) {
          errorMessage = 'Thiếu thông tin cần thiết. Vui lòng thử lại.';
        }
        
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
        return;
      }

      if (response.data == null) {
        state = AsyncValue.error(
          Exception('Không nhận được dữ liệu từ server. Vui lòng thử lại.'),
          StackTrace.current,
        );
        return;
      }

      final trialStatus = TrialStatus.fromEntity(response.data!);
      state = AsyncValue.data(trialStatus);
    } on TimeoutException catch (e, stackTrace) {
      state = AsyncValue.error(
        Exception(e.message ?? 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.'),
        stackTrace,
      );
    } on Failure catch (e, stackTrace) {
      String errorMessage = 'Không thể bắt đầu trial. Vui lòng thử lại.';
      if (e.type == FailureType.timeout) {
        errorMessage = 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.';
      } else if (e.type == FailureType.network) {
        errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.';
      }
      state = AsyncValue.error(Exception(errorMessage), stackTrace);
    } catch (e, stackTrace) {
      String errorMessage = 'Có lỗi xảy ra. Vui lòng thử lại sau.';
      if (e.toString().contains('timeout') || e.toString().contains('Timeout')) {
        errorMessage = 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.';
      }
      state = AsyncValue.error(Exception(errorMessage), stackTrace);
    }
  }

  Future<TrialStatus?> getTrialStatus() async {
    if (state.isLoading) return null;

    // Return cached value if available
    if (state.value != null) {
      return state.value;
    }

    state = const AsyncValue.loading();

    try {
      final repository = ref.read(trialRepositoryProvider);
      
      // Add timeout (10 seconds)
      final response = await repository.getTrialStatus().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException(
            'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.',
            const Duration(seconds: 10),
          );
        },
      );

      if (!response.isSuccess) {
        final errorCode = response.errorCode ?? ErrorCodes.internalError;
        
        // Handle specific error codes
        if (errorCode == ErrorCodes.trialNotFound) {
          state = const AsyncValue.data(null);
          return null;
        } else if (errorCode == ErrorCodes.trialExpired) {
          state = AsyncValue.error(
            Exception('Trial đã hết hạn.'),
            StackTrace.current,
          );
          return null;
        }
        
        String errorMessage = response.errorDetail ?? 'Không thể lấy trạng thái trial. Vui lòng thử lại.';
        state = AsyncValue.error(
          Exception(errorMessage),
          StackTrace.current,
        );
        return null;
      }

      if (response.data == null) {
        state = const AsyncValue.data(null);
        return null;
      }

      final trialStatus = TrialStatus.fromEntity(response.data!);
      state = AsyncValue.data(trialStatus);
      return trialStatus;
    } on TimeoutException catch (e, stackTrace) {
      state = AsyncValue.error(
        Exception(e.message ?? 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.'),
        stackTrace,
      );
      return null;
    } on Failure catch (e, stackTrace) {
      String errorMessage = 'Không thể lấy trạng thái trial. Vui lòng thử lại.';
      if (e.type == FailureType.timeout) {
        errorMessage = 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.';
      } else if (e.type == FailureType.network) {
        errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.';
      }
      state = AsyncValue.error(Exception(errorMessage), stackTrace);
      return null;
    } catch (e, stackTrace) {
      String errorMessage = 'Có lỗi xảy ra. Vui lòng thử lại sau.';
      if (e.toString().contains('timeout') || e.toString().contains('Timeout')) {
        errorMessage = 'Không thể kết nối. Vui lòng kiểm tra internet và thử lại.';
      }
      state = AsyncValue.error(Exception(errorMessage), stackTrace);
      return null;
    }
  }
}

