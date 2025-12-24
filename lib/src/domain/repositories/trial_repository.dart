import '../../core/base/repository.dart';
import '../../core/base/response_object.dart';
import '../entities/trial_entity.dart';

abstract base class TrialRepository extends Repository<void> {
  Future<ResponseObject<TrialEntity>> startTrial();
  Future<ResponseObject<TrialEntity>> getTrialStatus();
}

