import '../../core/extensions/app_localization.dart';
import 'package:flutter/material.dart';

/// Utility class to map technical errors to user-friendly messages
class ErrorMessageMapper {
  /// Get user-friendly error message from technical error
  static String getUserFriendlyMessage(BuildContext context, Object error) {
    final errorString = error.toString().toLowerCase();
    
    // Remove technical prefixes
    String message = errorString
        .replaceFirst('exception: ', '')
        .replaceFirst('error: ', '')
        .trim();

    // Map common error patterns to user-friendly messages
    if (message.contains('network') || message.contains('connection')) {
      return context.locale.error_network_connection;
    }
    
    if (message.contains('timeout')) {
      return context.locale.error_network_timeout;
    }
    
    if (message.contains('401') || message.contains('unauthorized')) {
      return context.locale.error_auth_unauthorized;
    }
    
    if (message.contains('403') || message.contains('forbidden')) {
      return context.locale.error_auth_forbidden;
    }
    
    if (message.contains('404') || message.contains('not found')) {
      return 'Không tìm thấy thông tin. Vui lòng thử lại sau.';
    }
    
    if (message.contains('500') || message.contains('internal')) {
      return context.locale.error_system_internal;
    }
    
    if (message.contains('unlock') || message.contains('not unlocked')) {
      return 'Mini test chưa được mở khóa. Hãy hoàn thành bài luyện tập trước.';
    }
    
    if (message.contains('chapter') && message.contains('not found')) {
      return 'Không tìm thấy thông tin chương học. Vui lòng kiểm tra lại.';
    }
    
    if (message.contains('skill') && message.contains('not found')) {
      return 'Không tìm thấy thông tin kỹ năng. Vui lòng kiểm tra lại.';
    }
    
    if (message.contains('session') && message.contains('not found')) {
      return 'Phiên học không tồn tại. Vui lòng bắt đầu lại.';
    }
    
    if (message.contains('empty') || message.contains('no data')) {
      return 'Chưa có dữ liệu. Vui lòng thử lại sau.';
    }

    // Return original message if no mapping found, but limit length
    if (message.length > 100) {
      message = '${message.substring(0, 100)}...';
    }
    return message;
  }

  /// Get error description for specific error types
  static String? getErrorDescription(BuildContext context, Object error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socket')) {
      return context.locale.error_network_generic;
    }
    
    return null;
  }
}

