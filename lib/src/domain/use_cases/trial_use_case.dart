import '../../core/base/response_object.dart';
import '../entities/trial_entity.dart';
import '../repositories/trial_repository.dart';

final class GetTrialStatusUseCase {
  GetTrialStatusUseCase(this.repository);

  final TrialRepository repository;

  Future<ResponseObject<TrialEntity>> call() async {
    return repository.getTrialStatus();
  }
}

