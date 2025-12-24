import '../../core/base/response_object.dart';
import '../repositories/onboarding_repository.dart';

final class SaveGradeUseCase {
  SaveGradeUseCase(this.repository);

  final OnboardingRepository repository;

  Future<ResponseObject<void>> call(int grade) async {
    // Validate grade (only 6 or 7)
    if (grade != 6 && grade != 7) {
      throw Exception('Lớp học không hợp lệ. Chỉ có thể chọn lớp 6 hoặc 7.');
    }
    return repository.saveGrade(grade);
  }
}

final class GetGradeUseCase {
  GetGradeUseCase(this.repository);

  final OnboardingRepository repository;

  Future<ResponseObject<int?>> call() async {
    return repository.getGrade();
  }
}

final class SaveLearningGoalsUseCase {
  SaveLearningGoalsUseCase(this.repository);

  final OnboardingRepository repository;

  Future<ResponseObject<void>> call(Set<String> goals) async {
    // Validate: minimum 1 selection required
    if (goals.isEmpty) {
      throw Exception('Vui lòng chọn ít nhất một mục tiêu học tập.');
    }
    return repository.saveLearningGoals(goals);
  }
}

final class GetLearningGoalsUseCase {
  GetLearningGoalsUseCase(this.repository);

  final OnboardingRepository repository;

  Future<ResponseObject<Set<String>>> call() async {
    return repository.getLearningGoals();
  }
}

