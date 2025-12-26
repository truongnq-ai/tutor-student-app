import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../../onboarding/riverpod/grade_provider.dart';

/// Helper to get grade from cache, trial status, or grade provider
class GradeHelper {
  /// Get grade from multiple sources with fallback
  static int? getGrade(WidgetRef ref) {
    // Try cache first
    final cacheService = ref.read(cacheServiceProvider);
    final cachedGrade = cacheService.get<int>(CacheKey.grade);
    if (cachedGrade != null) {
      return cachedGrade;
    }

    // Try grade provider
    final gradeState = ref.read(gradeSelectionProvider);
    final grade = gradeState.valueOrNull;
    if (grade != null) {
      return grade;
    }

    // Default to 6 if nothing found
    return 6;
  }
}

