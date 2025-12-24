import '../../core/base/response_object.dart';
import '../entities/trial_entity.dart';
import '../repositories/trial_repository.dart';

final class StartTrialUseCase {
  StartTrialUseCase(this.repository);

  final TrialRepository repository;

  Future<ResponseObject<TrialEntity>> call() async {
    return repository.startTrial();
  }
}

final class GetTrialStatusUseCase {
  GetTrialStatusUseCase(this.repository);

  final TrialRepository repository;

  Future<ResponseObject<TrialEntity>> call() async {
    return repository.getTrialStatus();
  }
}

