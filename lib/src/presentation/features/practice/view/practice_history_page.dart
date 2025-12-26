import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/skeleton/skeleton_list.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/practice_provider.dart';
import '../widgets/practice_card.dart';

class PracticeHistoryPage extends ConsumerStatefulWidget {
  const PracticeHistoryPage({super.key});

  @override
  ConsumerState<PracticeHistoryPage> createState() => _PracticeHistoryPageState();
}

class _PracticeHistoryPageState extends ConsumerState<PracticeHistoryPage> {
  int _currentPage = 0;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(practiceHistoryProvider.notifier).loadHistory(
            page: _currentPage,
            pageSize: _pageSize,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(practiceHistoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: HeadingSmallText(context.locale.practice_history_title),
      ),
      body: historyState.when(
        data: (data) {
          if (data == null) {
            return _buildEmptyState(context);
          }
          return _buildContent(context, data);
        },
        loading: () => const SkeletonList(itemCount: 5, itemHeight: 100),
        error: (error, stackTrace) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> data) {
    final content = data['content'] as List<dynamic>? ?? [];
    final totalPages = data['totalPages'] as int? ?? 0;

    if (content.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(practiceHistoryProvider.notifier).loadHistory(
              page: 0,
              pageSize: _pageSize,
            );
      },
      child: ListView.builder(
        padding: EdgeInsets.all(context.padding.p16),
        itemCount: content.length + (totalPages > _currentPage + 1 ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == content.length) {
            // Load more button
            return Padding(
              padding: EdgeInsets.all(context.padding.p16),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    _currentPage++;
                    ref.read(practiceHistoryProvider.notifier).loadHistory(
                          page: _currentPage,
                          pageSize: _pageSize,
                        );
                  },
                  child: Text(context.locale.common_button_load_more),
                ),
              ),
            );
          }

          final practice = content[index] as Map<String, dynamic>;
          return _buildPracticeCard(context, practice);
        },
      ),
    );
  }

  Widget _buildPracticeCard(BuildContext context, Map<String, dynamic> practice) {
    final isCorrect = practice['isCorrect'] as bool? ?? false;
    final skillName = practice['skillName'] as String? ?? 'N/A';
    final createdAt = practice['createdAt'] as String?;
    final masteryLevel = practice['masteryLevel'] as int?;
    final durationSec = practice['durationSec'] as int?;

    DateTime? date;
    if (createdAt != null) {
      try {
        date = DateTime.parse(createdAt);
      } catch (e) {
        // Ignore parse errors
      }
    }

    // Use PracticeCard component
    // Since API returns individual practices, we treat each as a session with 1 question
    if (date != null) {
      return PracticeCard(
        skillName: skillName,
        createdAt: date,
        correctCount: isCorrect ? 1 : 0,
        totalCount: 1,
        masteryChange: null, // Mastery change would need to be calculated from previous practice
        durationSec: durationSec,
        onTap: () {
          // Optional: Navigate to practice detail
        },
      );
    }

    // Fallback if date parsing fails
    return Card(
      margin: EdgeInsets.only(bottom: context.spacing.s8),
      child: ListTile(
        leading: Icon(
          isCorrect ? Icons.check_circle : Icons.cancel,
          color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
        ),
        title: Text(skillName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (masteryLevel != null)
              Text(
                context.locale.practice_history_mastery(masteryLevel),
                style: context.textStyle.bodySmall,
              ),
            if (durationSec != null)
              Text(
                context.locale.practice_history_duration(durationSec),
                style: context.textStyle.bodySmall,
              ),
          ],
        ),
        trailing: Icon(
          isCorrect ? Icons.check : Icons.close,
          color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      title: context.locale.practice_history_empty_title,
      description: context.locale.practice_history_empty_description,
      icon: Icons.history,
      onAction: () {
        // Navigate to skill selection or home
        // This would need to be implemented based on navigation structure
      },
      actionButtonText: context.locale.common_button_start_learning,
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    // Extract user-friendly error message
    String errorMessage = _getUserFriendlyErrorMessage(error);
    String? description;

    // Check if it's a network error
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('socket')) {
      description = context.locale.error_network_generic;
    }

    return ErrorStateWidget(
      title: context.locale.practice_history_load_error,
      description: description ?? errorMessage,
      onRetry: () {
        ref.read(practiceHistoryProvider.notifier).loadHistory(
              page: 0,
              pageSize: _pageSize,
            );
      },
    );
  }

  String _getUserFriendlyErrorMessage(Object error) {
    final errorString = error.toString();
    
    // Remove technical prefixes
    String message = errorString
        .replaceFirst('Exception: ', '')
        .replaceFirst('Error: ', '')
        .trim();

    // Map common error patterns to user-friendly messages
    if (message.toLowerCase().contains('network') ||
        message.toLowerCase().contains('connection')) {
      return context.locale.error_network_connection;
    }
    if (message.toLowerCase().contains('timeout')) {
      return context.locale.error_network_timeout;
    }
    if (message.toLowerCase().contains('401') ||
        message.toLowerCase().contains('unauthorized')) {
      return context.locale.error_auth_unauthorized;
    }
    if (message.toLowerCase().contains('500') ||
        message.toLowerCase().contains('internal')) {
      return context.locale.error_system_internal;
    }

    // Return original message if no mapping found, but limit length
    if (message.length > 100) {
      message = '${message.substring(0, 100)}...';
    }
    return message;
  }
}

