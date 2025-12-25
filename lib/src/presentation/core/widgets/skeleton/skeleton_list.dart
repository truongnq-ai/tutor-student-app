import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import 'skeleton_card.dart';

/// Skeleton list widget with multiple skeleton cards.
///
/// Used to show loading state for lists. Supports pagination skeleton.
class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    this.itemCount = 3,
    this.itemHeight = 120,
    this.spacing = 12,
    this.padding,
    this.showPagination = false,
  });

  /// Number of skeleton items to show. Defaults to 3.
  final int itemCount;

  /// Height of each skeleton item. Defaults to 120.
  final double itemHeight;

  /// Spacing between items. Defaults to 12.
  final double spacing;

  /// List padding. Defaults to 16.
  final EdgeInsets? padding;

  /// Whether to show pagination skeleton at the bottom. Defaults to false.
  final bool showPagination;

  @override
  Widget build(BuildContext context) {
    final defaultPadding = padding ?? EdgeInsets.all(context.padding.p16);

    return ListView.builder(
      padding: defaultPadding,
      itemCount: itemCount + (showPagination ? 1 : 0),
      itemBuilder: (context, index) {
        if (showPagination && index == itemCount) {
          // Pagination skeleton
          return Padding(
            padding: EdgeInsets.all(context.padding.p16),
            child: Center(
              child: SkeletonCard(
                height: 40,
                padding: EdgeInsets.symmetric(
                  horizontal: context.padding.p16,
                  vertical: context.padding.p8,
                ),
              ),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: SkeletonCard(height: itemHeight),
        );
      },
    );
  }
}

