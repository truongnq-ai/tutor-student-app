import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Difficulty badge widget showing difficulty level with color coding.
///
/// Follows design standards with color coding:
/// - Easy (1): Green (#4CAF50)
/// - Medium (2): Blue (#2196F3)
/// - Medium-Hard (3): Orange (#FF9800)
/// - Hard (4): Orange (#FF9800)
/// - Very Hard (5): Red (#F44336)
class DifficultyBadge extends StatelessWidget {
  final int difficulty; // 1-5
  final String? customText;

  const DifficultyBadge({
    super.key,
    required this.difficulty,
    this.customText,
  });

  @override
  Widget build(BuildContext context) {
    final (text, color) = _getDifficultyInfo(difficulty);
    final displayText = customText ?? 'Độ khó: $text';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.padding.p12,
        vertical: context.padding.p8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        displayText,
        style: context.textStyle.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (String, Color) _getDifficultyInfo(int difficulty) {
    switch (difficulty) {
      case 1:
        return ('Dễ', const Color(0xFF4CAF50));
      case 2:
        return ('Trung bình', const Color(0xFF2196F3));
      case 3:
        return ('Trung bình', const Color(0xFFFF9800));
      case 4:
        return ('Khó', const Color(0xFFFF9800));
      case 5:
        return ('Rất khó', const Color(0xFFF44336));
      default:
        return ('Trung bình', const Color(0xFFFF9800));
    }
  }
}

