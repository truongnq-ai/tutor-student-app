import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'grade_provider.g.dart';

@riverpod
class GradeSelection extends _$GradeSelection {
  @override
  int? build() {
    // Mock: Get from local storage or return null
    // In real implementation, this would read from cache/local storage
    return null;
  }

  Future<void> selectGrade(int grade) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    try {
      // Mock: Save grade selection (local storage)
      // In real implementation, this would call the API and save to local storage
      await Future.delayed(const Duration(milliseconds: 500));

      // Validate grade (only 6 or 7)
      if (grade != 6 && grade != 7) {
        throw Exception('Lớp học không hợp lệ. Chỉ có thể chọn lớp 6 hoặc 7.');
      }

      state = AsyncValue.data(grade);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  int? getSelectedGrade() {
    return state.value;
  }
}

