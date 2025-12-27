import '../constants/error_codes.dart';

/// Error handler helper to map error codes to user-friendly messages
class ErrorHandler {
  /// Get user-friendly error message from error code and detail
  ///
  /// If errorDetail is provided and not empty, it will be used.
  /// Otherwise, a default message based on errorCode will be returned.
  static String getErrorMessage(String errorCode, String? errorDetail) {
    // Use errorDetail if available and not empty
    if (errorDetail != null && errorDetail.isNotEmpty) {
      return errorDetail;
    }

    // Map error codes to default messages
    switch (errorCode) {
      // Authentication & Authorization
      case ErrorCodes.unauthorized:
        return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
      case ErrorCodes.tokenExpired:
        return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
      case ErrorCodes.forbidden:
        return 'Bạn không có quyền thực hiện thao tác này.';
      case ErrorCodes.phoneNotVerified:
        return 'Số điện thoại chưa được xác thực. '
            'Vui lòng xác thực số điện thoại.';

      // Validation
      case ErrorCodes.validationError:
        return 'Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.';
      case ErrorCodes.missingField:
        return 'Vui lòng điền đầy đủ thông tin.';
      case ErrorCodes.invalidFormat:
        return 'Định dạng dữ liệu không đúng.';
      case ErrorCodes.otpInvalid:
        return 'Mã OTP không đúng. Vui lòng thử lại.';
      case ErrorCodes.otpExpired:
        return 'Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.';
      case ErrorCodes.recaptchaFailed:
        return 'Xác thực reCAPTCHA thất bại. Vui lòng thử lại.';

      // Resource errors
      case ErrorCodes.notFound:
        return 'Không tìm thấy dữ liệu.';
      case ErrorCodes.conflict:
        return 'Dữ liệu đã tồn tại hoặc xung đột.';
      case ErrorCodes.questionNotFound:
        return 'Không tìm thấy câu hỏi.';
      case ErrorCodes.questionNotAssigned:
        return 'Câu hỏi chưa được gán cho bạn.';
      case ErrorCodes.questionAlreadyCompleted:
        return 'Câu hỏi đã được hoàn thành.';
      case ErrorCodes.questionStudentMismatch:
        return 'Câu hỏi không thuộc về học sinh này.';
      case ErrorCodes.exerciseNotApproved:
        return 'Bài tập chưa được phê duyệt.';

      // Service integration
      case ErrorCodes.serviceUnavailable:
        return 'Dịch vụ tạm thời không khả dụng. Vui lòng thử lại sau.';
      case ErrorCodes.aiServiceUnavailable:
        return 'Dịch vụ AI tạm thời không khả dụng. Vui lòng thử lại sau.';

      // System errors
      case ErrorCodes.internalError:
        return 'Lỗi hệ thống. Vui lòng thử lại sau.';
      case ErrorCodes.databaseError:
        return 'Lỗi cơ sở dữ liệu. Vui lòng thử lại sau.';
      case ErrorCodes.networkError:
        return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet.';

      // Special errors
      case ErrorCodes.trialExpired:
        return 'Thời gian dùng thử đã hết hạn. '
            'Vui lòng đăng ký để tiếp tục sử dụng.';
      case ErrorCodes.skillNotUnlocked:
        return 'Kỹ năng này chưa được mở khóa. '
            'Vui lòng hoàn thành các kỹ năng trước đó.';
      case ErrorCodes.prerequisiteNotMet:
        return 'Chưa đạt yêu cầu tiên quyết. '
            'Vui lòng hoàn thành các kỹ năng cần thiết.';
      case ErrorCodes.rateLimitExceeded:
        return 'Bạn đã vượt quá giới hạn yêu cầu. Vui lòng thử lại sau.';

      // Business errors
      case ErrorCodes.businessError:
        return 'Có lỗi xảy ra. Vui lòng thử lại.';

      default:
        // Check error code range for generic messages
        if (ErrorCodes.isAuthError(errorCode)) {
          return 'Lỗi xác thực. Vui lòng đăng nhập lại.';
        } else if (ErrorCodes.isValidationError(errorCode)) {
          return 'Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.';
        } else if (ErrorCodes.isResourceError(errorCode)) {
          return 'Không tìm thấy tài nguyên.';
        } else if (ErrorCodes.isServiceError(errorCode)) {
          return 'Dịch vụ tạm thời không khả dụng.';
        } else if (ErrorCodes.isSystemError(errorCode)) {
          return 'Lỗi hệ thống. Vui lòng thử lại sau.';
        } else {
          return 'Có lỗi xảy ra. Vui lòng thử lại.';
        }
    }
  }

  /// Check if error code indicates a retryable error
  static bool isRetryable(String errorCode) {
    return errorCode == ErrorCodes.networkError ||
        errorCode == ErrorCodes.serviceUnavailable ||
        errorCode == ErrorCodes.aiServiceUnavailable ||
        errorCode == ErrorCodes.internalError ||
        errorCode == ErrorCodes.databaseError;
  }

  /// Check if error code requires user action (login, verification, etc.)
  static bool requiresUserAction(String errorCode) {
    return errorCode == ErrorCodes.unauthorized ||
        errorCode == ErrorCodes.tokenExpired ||
        errorCode == ErrorCodes.phoneNotVerified ||
        errorCode == ErrorCodes.trialExpired;
  }
}
