import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

/// Animated mastery progress bar showing mastery level change
class MasteryProgressBar extends StatefulWidget {
  final int currentMastery; // 0-100
  final int? previousMastery; // For animation
  final bool showLabel;
  final double height;

  const MasteryProgressBar({
    super.key,
    required this.currentMastery,
    this.previousMastery,
    this.showLabel = true,
    this.height = 8,
  });

  @override
  State<MasteryProgressBar> createState() => _MasteryProgressBarState();
}

class _MasteryProgressBarState extends State<MasteryProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: (widget.previousMastery ?? 0) / 100.0,
      end: widget.currentMastery / 100.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(MasteryProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentMastery != widget.currentMastery) {
      _animation = Tween<double>(
        begin: oldWidget.currentMastery / 100.0,
        end: widget.currentMastery / 100.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final masteryChange = widget.previousMastery != null
        ? widget.currentMastery - widget.previousMastery!
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mastery',
                style: context.textStyle.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (masteryChange != null && masteryChange != 0)
                Text(
                  masteryChange > 0
                      ? '${widget.previousMastery}% → ${widget.currentMastery}% (+$masteryChange%)'
                      : '${widget.previousMastery}% → ${widget.currentMastery}% ($masteryChange%)',
                  style: context.textStyle.bodySmall.copyWith(
                    color: masteryChange > 0
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFF44336),
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                Text(
                  '${widget.currentMastery}%',
                  style: context.textStyle.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          Gap(context.spacing.s8),
        ],
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(widget.height / 2),
              child: LinearProgressIndicator(
                value: _animation.value.clamp(0.0, 1.0),
                minHeight: widget.height,
                backgroundColor: const Color(0xFFE0E0E0),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getMasteryColor(widget.currentMastery),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getMasteryColor(int mastery) {
    if (mastery >= 90) {
      return const Color(0xFF4CAF50); // Green
    } else if (mastery >= 70) {
      return const Color(0xFF2196F3); // Blue
    } else if (mastery >= 40) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFF44336); // Red
    }
  }
}

