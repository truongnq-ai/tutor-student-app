/// Entity for student status check response.
class StudentCheckEntity {
  /// Status of the student:
  /// - NO_TRIAL: User chưa có trial
  /// - TRIAL_ACTIVE_DEVICE_CONSUMED: User đang trial nhưng device đã CONSUMED
  /// - TRIAL_ACTIVE: User đang trial được phép sử dụng
  /// - LICENCE_ACTIVE: User đang trong licence
  /// - LICENCE_EXPIRED: User đã có licence nhưng hết hạn
  /// - TRIAL_EXPIRED_NO_LICENCE: User đã hết trial nhưng chưa có licence
  final String status;

  /// Number of days remaining (for active trial/licence).
  /// Null if expired or no trial/licence.
  final int? daysRemaining;

  /// Number of days expired (for expired trial/licence).
  /// Null if active or no trial/licence.
  final int? daysExpired;

  /// Expiration date/time.
  /// Null if no trial/licence.
  final DateTime? expiresAt;

  /// Message for frontend display.
  /// Null if no message needed.
  final String? message;

  StudentCheckEntity({
    required this.status,
    this.daysRemaining,
    this.daysExpired,
    this.expiresAt,
    this.message,
  });
}

