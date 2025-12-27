import '../../domain/entities/student_check_entity.dart';

class StudentCheckModel extends StudentCheckEntity {
  StudentCheckModel({
    required super.status,
    super.daysRemaining,
    super.daysExpired,
    super.expiresAt,
    super.message,
  });

  factory StudentCheckModel.fromJson(Map<String, dynamic> json) {
    return StudentCheckModel(
      status: json['status'] as String,
      daysRemaining: json['daysRemaining'] as int?,
      daysExpired: json['daysExpired'] as int?,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      if (daysRemaining != null) 'daysRemaining': daysRemaining,
      if (daysExpired != null) 'daysExpired': daysExpired,
      if (expiresAt != null) 'expiresAt': expiresAt!.toIso8601String(),
      if (message != null) 'message': message,
    };
  }
}

