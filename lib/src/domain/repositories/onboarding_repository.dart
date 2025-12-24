import '../../core/base/repository.dart';
import '../../core/base/response_object.dart';

abstract base class OnboardingRepository extends Repository<void> {
  Future<ResponseObject<void>> saveGrade(int grade);
  Future<ResponseObject<int?>> getGrade();
  Future<ResponseObject<void>> saveLearningGoals(Set<String> goals);
  Future<ResponseObject<Set<String>>> getLearningGoals();
}

