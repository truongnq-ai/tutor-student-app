import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/theme.dart';

/// Skeleton card widget with shimmer effect.
///
/// Used to show loading state for cards. Follows design standards
/// with configurable height, padding, and border radius.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.height = 120,
    this.padding,
    this.borderRadius,
    this.margin,
  });

  /// Card height. Defaults to 120.
  final double height;

  /// Card padding. Defaults to 16.
  final EdgeInsets? padding;

  /// Border radius. Defaults to 12.
  final BorderRadius? borderRadius;

  /// Card margin. Defaults to EdgeInsets.zero.
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final defaultPadding = padding ?? EdgeInsets.all(context.padding.p16);
    final defaultBorderRadius =
        borderRadius ?? BorderRadius.circular(12);
    final defaultMargin = margin ?? EdgeInsets.zero;

    return Container(
      height: height,
      margin: defaultMargin,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: defaultBorderRadius,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          padding: defaultPadding,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: defaultBorderRadius,
          ),
        ),
      ),
    );
  }
}

