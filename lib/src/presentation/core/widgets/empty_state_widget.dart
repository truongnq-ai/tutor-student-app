import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';
import 'text/typography.dart';

/// Reusable empty state widget following design standards.
///
/// Displays an icon, title, description, and optional CTA button.
/// Follows the design pattern from interaction-patterns.md.
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.iconSize = 64,
    this.iconColor,
    this.onAction,
    this.actionButtonText,
    this.actionButton,
  });

  /// Empty state title (e.g., "Chưa có bài tập nào")
  final String title;

  /// Optional description (e.g., "Hãy bắt đầu học để xem bài tập ở đây")
  final String? description;

  /// Optional custom icon. Defaults to assignment_outlined icon.
  final IconData? icon;

  /// Icon size. Defaults to 64.
  final double iconSize;

  /// Icon color. Defaults to grey.
  final Color? iconColor;

  /// Optional action callback. If provided, an action button will be shown.
  final VoidCallback? onAction;

  /// Action button text. Required if onAction is provided.
  final String? actionButtonText;

  /// Optional custom action button widget.
  /// If provided, this will be used instead of the default button.
  final Widget? actionButton;

  @override
  Widget build(BuildContext context) {
    final defaultIconColor = iconColor ?? const Color(0xFFBDBDBD);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.assignment_outlined,
              size: iconSize,
              color: defaultIconColor,
            ),
            Gap(context.spacing.s16),
            HeadingSmallText(
              title,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              Gap(context.spacing.s8),
              Text(
                description!,
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null || actionButton != null) ...[
              Gap(context.spacing.s24),
              if (actionButton != null)
                actionButton!
              else
                FilledButton(
                  onPressed: onAction,
                  child: Text(actionButtonText ?? context.locale.core_widget_empty_action_default),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

