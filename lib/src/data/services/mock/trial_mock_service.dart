import '../../../core/base/response_object.dart';
import '../../../domain/entities/trial_entity.dart';
import '../../models/trial_model.dart';

/// Mock service for trial operations
/// In production, this would be replaced with real API service
class TrialMockService {
  Future<ResponseObject<TrialEntity>> getTrialStatus() async {
    // Mock: Simulate API call delay
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 5));

    final trial = TrialModel(
      daysRemaining: 5,
      daysUsed: 2,
      totalDays: 7,
      startDate: now.subtract(const Duration(days: 2)),
      endDate: endDate,
      solvesToday: 3,
      maxSolvesPerDay: 5,
      totalExercises: 45,
      skillsLearned: 8,
      isLinked: false,
    );

    return ResponseObject<TrialEntity>.success(trial);
  }
}

