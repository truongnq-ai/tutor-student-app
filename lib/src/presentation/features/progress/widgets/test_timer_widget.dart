import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

/// Timer widget for mini test with countdown and warning state
class TestTimerWidget extends StatefulWidget {
  final int remainingSeconds;
  final VoidCallback? onExpired;
  final bool showWarning;

  const TestTimerWidget({
    super.key,
    required this.remainingSeconds,
    this.onExpired,
    this.showWarning = true,
  });

  @override
  State<TestTimerWidget> createState() => _TestTimerWidgetState();
}

class _TestTimerWidgetState extends State<TestTimerWidget> {
  late Timer _timer;
  int _remainingSeconds = 0;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.remainingSeconds;
    _startTimer();
  }

  @override
  void didUpdateWidget(TestTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.remainingSeconds != widget.remainingSeconds) {
      _remainingSeconds = widget.remainingSeconds;
      if (!_isExpired) {
        _timer.cancel();
        _startTimer();
      }
    }
  }

  void _startTimer() {
    if (_remainingSeconds <= 0) {
      _isExpired = true;
      widget.onExpired?.call();
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _remainingSeconds--;
          if (_remainingSeconds <= 0) {
            _remainingSeconds = 0;
            _isExpired = true;
            timer.cancel();
            widget.onExpired?.call();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isWarning = widget.showWarning && _remainingSeconds < 120; // < 2 minutes
    final isExpired = _isExpired || _remainingSeconds == 0;

    return Semantics(
      label: 'Thời gian còn lại: ${_formatTime(_remainingSeconds)}',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.padding.p12,
          vertical: context.padding.p8,
        ),
        decoration: BoxDecoration(
          color: isExpired
              ? const Color(0xFFF44336)
              : isWarning
                  ? const Color(0xFFFF9800).withValues(alpha:0.1)
                  : context.color.primary.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isExpired
                ? const Color(0xFFF44336)
                : isWarning
                    ? const Color(0xFFFF9800)
                    : context.color.primary,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time,
              size: 20,
              color: isExpired
                  ? Colors.white
                  : isWarning
                      ? const Color(0xFFFF9800)
                      : context.color.primary,
            ),
            const SizedBox(width: 8),
            Text(
              isExpired ? 'Hết thời gian' : _formatTime(_remainingSeconds),
              style: context.textStyle.headingSmall.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isExpired
                    ? Colors.white
                    : isWarning
                        ? const Color(0xFFFF9800)
                        : context.color.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

