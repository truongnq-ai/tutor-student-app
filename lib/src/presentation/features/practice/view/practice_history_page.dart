import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/practice_provider.dart';

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
        title: const HeadingSmallText('Lịch sử luyện tập'),
      ),
      body: historyState.when(
        data: (data) {
          if (data == null) {
            return _buildEmptyState(context);
          }
          return _buildContent(context, data);
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stackTrace) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> data) {
    final content = data['content'] as List<dynamic>? ?? [];
    final totalElements = data['totalElements'] as int? ?? 0;
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
                  child: const Text('Tải thêm'),
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
            if (date != null)
              Text(
                '${date.day}/${date.month}/${date.year}',
                style: context.textStyle.bodySmall,
              ),
            if (masteryLevel != null)
              Text(
                'Mastery: $masteryLevel%',
                style: context.textStyle.bodySmall,
              ),
            if (durationSec != null)
              Text(
                'Thời gian: ${durationSec}s',
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
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history, size: 64, color: Color(0xFFBDBDBD)),
            Gap(context.spacing.s16),
            Text(
              'Bạn chưa có bài luyện tập nào',
              style: context.textStyle.headingSmall,
              textAlign: TextAlign.center,
            ),
            Gap(context.spacing.s8),
            Text(
              'Hãy bắt đầu học để xem lịch sử ở đây',
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFFF44336)),
            Gap(context.spacing.s16),
            Text(
              'Không thể tải lịch sử',
              style: context.textStyle.headingSmall,
              textAlign: TextAlign.center,
            ),
            Gap(context.spacing.s8),
            Text(
              error.toString(),
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(context.spacing.s24),
            FilledButton(
              onPressed: () {
                ref.read(practiceHistoryProvider.notifier).loadHistory(
                      page: 0,
                      pageSize: _pageSize,
                    );
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

