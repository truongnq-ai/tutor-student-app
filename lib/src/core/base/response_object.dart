/// Standard API response object matching backend specification
/// 
/// All API responses follow this structure:
/// - Success: errorCode "0000" or null, data contains the response
/// - Error: errorCode contains error code, errorDetail contains message, data may be null
class ResponseObject<T> {
  const ResponseObject({
    this.errorCode,
    this.errorDetail,
    this.data,
  });

  /// Error code from backend
  /// - "0000" or null: Success
  /// - "0001"-"0999": Business errors
  /// - "1000"-"1999": Authentication & Authorization errors
  /// - "2000"-"2999": Validation errors
  /// - "3000"-"3999": Resource errors
  /// - "4000"-"4999": Service integration errors
  /// - "5000"-"5999": System errors
  final String? errorCode;

  /// Human-readable error message
  final String? errorDetail;

  /// Response data (null on error)
  final T? data;

  /// Check if response is successful
  bool get isSuccess => errorCode == null || errorCode == '0000';

  /// Check if response has error
  bool get hasError => !isSuccess;

  /// Get error message (errorDetail or default)
  String getErrorMessage([String defaultMessage = 'Có lỗi xảy ra. Vui lòng thử lại.']) {
    return errorDetail?.isNotEmpty == true ? errorDetail! : defaultMessage;
  }

  /// Factory constructor for success response
  factory ResponseObject.success(T data) {
    return ResponseObject<T>(
      errorCode: '0000',
      errorDetail: null,
      data: data,
    );
  }

  /// Factory constructor for error response
  factory ResponseObject.error({
    required String errorCode,
    required String errorDetail,
    T? data,
  }) {
    return ResponseObject<T>(
      errorCode: errorCode,
      errorDetail: errorDetail,
      data: data,
    );
  }

  /// Create from JSON map
  factory ResponseObject.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ResponseObject<T>(
      errorCode: json['errorCode'] as String?,
      errorDetail: json['errorDetail'] as String?,
      data: json['data'] != null
          ? (fromJsonT != null ? fromJsonT(json['data']) : json['data'] as T)
          : null,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson([dynamic Function(T)? toJsonT]) {
    return {
      'errorCode': errorCode,
      'errorDetail': errorDetail,
      'data': data != null
          ? (toJsonT != null ? toJsonT(data as T) : data)
          : null,
    };
  }
}

