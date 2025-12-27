import '../../core/base/response_object.dart';
import '../repositories/onboarding_repository.dart';

final class GetGradeUseCase {
  GetGradeUseCase(this.repository);

  final OnboardingRepository repository;

  Future<ResponseObject<int?>> call() async {
    return repository.getGrade();
  }
}

final class GetLearningGoalsUseCase {
  GetLearningGoalsUseCase(this.repository);

  final OnboardingRepository repository;

  Future<ResponseObject<Set<String>>> call() async {
    return repository.getLearningGoals();
  }
}

