import '../../core/base/repository.dart';
import '../../core/base/response_object.dart';
import '../entities/student_check_entity.dart';
import '../entities/trial_entity.dart';

abstract base class TrialRepository extends Repository<void> {
  Future<ResponseObject<TrialEntity>> getTrialStatus();
  Future<ResponseObject<StudentCheckEntity>> checkStudentStatus();
  Future<ResponseObject<TrialEntity>> createTrial({
    required int grade,
    required List<String> learningGoals,
  });
}
