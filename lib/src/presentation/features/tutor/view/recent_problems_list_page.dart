import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/skeleton/skeleton_list.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/tutor_provider.dart';

class RecentProblemsListPage extends ConsumerStatefulWidget {
  const RecentProblemsListPage({super.key});

  @override
  ConsumerState<RecentProblemsListPage> createState() => _RecentProblemsListPageState();
}

class _RecentProblemsListPageState extends ConsumerState<RecentProblemsListPage> {
  String _selectedFilter = 'all'; // 'all', 'today', 'week'
  int _currentPage = 0;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecentProblems();
    });
  }

  Future<void> _loadRecentProblems() async {
    await ref.read(recentProblemsProvider.notifier).loadRecentProblems(
          page: _currentPage,
          pageSize: _pageSize,
        );
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
      _currentPage = 0;
    });
    _loadRecentProblems();
  }

  @override
  Widget build(BuildContext context) {
    final recentProblemsState = ref.watch(recentProblemsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const HeadingSmallText('Đề bài gần đây'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.padding.p16,
              vertical: context.padding.p12,
            ),
            color: Colors.white,
            child: Row(
              children: [
                _FilterChip(
                  label: 'Tất cả',
                  isSelected: _selectedFilter == 'all',
                  onTap: () => _onFilterChanged('all'),
                ),
                Gap(context.spacing.s8),
                _FilterChip(
                  label: 'Hôm nay',
                  isSelected: _selectedFilter == 'today',
                  onTap: () => _onFilterChanged('today'),
                ),
                Gap(context.spacing.s8),
                _FilterChip(
                  label: 'Tuần này',
                  isSelected: _selectedFilter == 'week',
                  onTap: () => _onFilterChanged('week'),
                ),
              ],
            ),
          ),

          // Problems list
          Expanded(
            child: recentProblemsState.when(
              data: (data) {
                if (data == null || data['content'] == null) {
                  return _buildEmptyState(context);
                }

                final content = data['content'] as List<dynamic>?;
                if (content == null || content.isEmpty) {
                  return _buildEmptyState(context);
                }

                // Apply filter
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final weekAgo = today.subtract(const Duration(days: 7));

                final filteredContent = content.where((problem) {
                  final solvedAtStr = problem['solvedAt'] as String?;
                  if (solvedAtStr == null) return false;

                  try {
                    final solvedAt = DateTime.parse(solvedAtStr);
                    if (_selectedFilter == 'today') {
                      return solvedAt.isAfter(today);
                    } else if (_selectedFilter == 'week') {
                      return solvedAt.isAfter(weekAgo);
                    }
                    return true; // 'all'
                  } catch (e) {
                    return false;
                  }
                }).toList();

                if (filteredContent.isEmpty) {
                  return _buildEmptyState(context);
                }

                return RefreshIndicator(
                  onRefresh: _loadRecentProblems,
                  child: ListView.builder(
                    padding: EdgeInsets.all(context.padding.p16),
                    itemCount: filteredContent.length,
                    itemBuilder: (context, index) {
                      final problem = filteredContent[index] as Map<String, dynamic>;
                      return _RecentProblemCard(
                        problem: problem,
                        onTap: () {
                          // TODO: Navigate to solution view
                          // For now, show a message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tính năng xem lại lời giải sẽ được thêm sau'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const SkeletonList(
                    itemCount: 5,
                    itemHeight: 120,
                  ),
              error: (error, stackTrace) => _buildErrorState(context, error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      title: 'Chưa có đề bài nào',
      description: _selectedFilter == 'all'
          ? 'Bạn chưa giải bài nào. Hãy bắt đầu giải bài Toán!'
          : _selectedFilter == 'today'
              ? 'Bạn chưa giải bài nào hôm nay.'
              : 'Bạn chưa giải bài nào trong tuần này.',
      icon: Icons.assignment_outlined,
      actionButton: ElevatedButton(
        onPressed: () {
          context.push(Routes.tutorModeEntry);
        },
        child: const Text('Giải bài ngay'),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Color(0xFFF44336),
          ),
          Gap(context.spacing.s16),
          Text(
            'Không thể tải danh sách',
            style: context.textStyle.headingSmall,
          ),
          Gap(context.spacing.s8),
          Text(
            error.toString(),
            style: context.textStyle.bodyMedium.copyWith(
              color: context.color.text.secondary,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(context.spacing.s24),
          ElevatedButton(
            onPressed: _loadRecentProblems,
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Lọc: $label',
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.padding.p16,
            vertical: context.padding.p8,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF4CAF50)
                : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE0E0E0),
            ),
          ),
          child: Text(
            label,
            style: context.textStyle.bodyMedium.copyWith(
              color: isSelected ? Colors.white : const Color(0xFF212121),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentProblemCard extends StatelessWidget {
  final Map<String, dynamic> problem;
  final VoidCallback onTap;

  const _RecentProblemCard({
    required this.problem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final problemText = problem['problemText'] as String? ?? '';
    final finalAnswer = problem['finalAnswer'] as String?;
    final imageUrl = problem['imageUrl'] as String?;
    final solvedAtStr = problem['solvedAt'] as String?;
    final relatedSkills = problem['relatedSkills'] as List<dynamic>?;

    String? formattedDate;
    if (solvedAtStr != null) {
      try {
        final solvedAt = DateTime.parse(solvedAtStr);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));

        if (solvedAt.isAfter(today)) {
          formattedDate = 'Hôm nay ${DateFormat('HH:mm').format(solvedAt)}';
        } else if (solvedAt.isAfter(yesterday)) {
          formattedDate = 'Hôm qua ${DateFormat('HH:mm').format(solvedAt)}';
        } else {
          formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(solvedAt);
        }
      } catch (e) {
        formattedDate = solvedAtStr;
      }
    }

    return Semantics(
      label: 'Đề bài: $problemText',
      button: true,
      child: Container(
        margin: EdgeInsets.only(bottom: context.spacing.s12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(context.padding.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image thumbnail (if available)
                      if (imageUrl != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                color: const Color(0xFFF5F5F5),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 24,
                                  color: Color(0xFFBDBDBD),
                                ),
                              );
                            },
                          ),
                        ),
                        Gap(context.spacing.s12),
                      ],

                      // Problem text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              problemText.length > 100
                                  ? '${problemText.substring(0, 100)}...'
                                  : problemText,
                              style: context.textStyle.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (finalAnswer != null) ...[
                              Gap(context.spacing.s4),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.padding.p8,
                                  vertical: context.padding.p4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Đáp án: $finalAnswer',
                                  style: context.textStyle.bodySmall.copyWith(
                                    color: const Color(0xFF4CAF50),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Related skills (if available)
                  if (relatedSkills != null && relatedSkills.isNotEmpty) ...[
                    Gap(context.spacing.s8),
                    Wrap(
                      spacing: context.spacing.s4,
                      runSpacing: context.spacing.s4,
                      children: relatedSkills.take(3).map((skill) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.padding.p8,
                            vertical: context.padding.p4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            skill.toString(),
                            style: context.textStyle.bodySmall.copyWith(
                              color: const Color(0xFF1976D2),
                              fontSize: 11,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  // Date
                  if (formattedDate != null) ...[
                    Gap(context.spacing.s8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Color(0xFF757575),
                        ),
                        Gap(context.spacing.s4),
                        Text(
                          formattedDate,
                          style: context.textStyle.bodySmall.copyWith(
                            color: const Color(0xFF757575),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

