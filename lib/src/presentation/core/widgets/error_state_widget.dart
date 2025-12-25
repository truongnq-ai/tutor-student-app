import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../theme/theme.dart';
import 'text/typography.dart';

/// Reusable error state widget following design standards.
///
/// Displays an error icon, title, description, and optional retry button.
/// Follows the design pattern from interaction-patterns.md.
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    required this.title,
    this.description,
    this.onRetry,
    this.icon,
    this.iconSize = 64,
    this.retryButtonText = 'Thử lại',
  });

  /// Error title (e.g., "Không thể kết nối")
  final String title;

  /// Optional error description (e.g., "Vui lòng kiểm tra kết nối internet")
  final String? description;

  /// Optional retry callback. If provided, a retry button will be shown.
  final VoidCallback? onRetry;

  /// Optional custom icon. Defaults to error_outline icon.
  final IconData? icon;

  /// Icon size. Defaults to 64.
  final double iconSize;

  /// Retry button text. Defaults to "Thử lại".
  final String retryButtonText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: iconSize,
              color: const Color(0xFFF44336),
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
                style: context.textStyle.bodyMedium.copyWith(
                  color: context.color.text.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              Gap(context.spacing.s24),
              FilledButton(
                onPressed: onRetry,
                child: Text(retryButtonText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

