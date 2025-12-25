import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/theme.dart';

/// Skeleton widget for practice question screen.
///
/// Shows skeleton for question card and answer options.
class SkeletonQuestion extends StatelessWidget {
  const SkeletonQuestion({
    super.key,
    this.optionCount = 4,
    this.optionHeight = 56,
  });

  /// Number of answer options. Defaults to 4.
  final int optionCount;

  /// Height of each option. Defaults to 56.
  final double optionHeight;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.padding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question card skeleton
          _SkeletonBox(
            height: 120,
            borderRadius: BorderRadius.circular(12),
          ),
          Gap(context.spacing.s24),

          // Answer options skeleton
          ...List.generate(
            optionCount,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: context.spacing.s12),
              child: _SkeletonBox(
                height: optionHeight,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal skeleton box widget with shimmer effect.
class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.height,
    required this.borderRadius,
  });

  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}

