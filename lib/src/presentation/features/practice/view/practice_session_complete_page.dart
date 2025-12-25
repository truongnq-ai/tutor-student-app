import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../widgets/mastery_progress_bar.dart';

class PracticeSessionCompletePage extends ConsumerStatefulWidget {
  const PracticeSessionCompletePage({super.key});

  @override
  ConsumerState<PracticeSessionCompletePage> createState() => _PracticeSessionCompletePageState();
}

class _PracticeSessionCompletePageState extends ConsumerState<PracticeSessionCompletePage>
    with SingleTickerProviderStateMixin {
  // Parse parameters from route
  int? _totalQuestions;
  int? _correctCount;
  int? _wrongCount;
  int? _previousMastery;
  int? _currentMastery;
  String? _skillName;
  String? _skillId;
  String? _sessionId;
  late AnimationController _celebrationController;
  late Animation<double> _celebrationAnimation;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _celebrationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _celebrationController,
        curve: Curves.elasticOut,
      ),
    );
    _celebrationController.forward();
    _parseRouteParameters();
  }

  void _parseRouteParameters() {
    // Get GoRouterState from context
    final routerState = GoRouterState.of(context);
    final uri = routerState.uri;
    
    // Parse query parameters
    _totalQuestions = int.tryParse(uri.queryParameters['totalQuestions'] ?? '');
    _correctCount = int.tryParse(uri.queryParameters['correctCount'] ?? '');
    _wrongCount = int.tryParse(uri.queryParameters['wrongCount'] ?? '');
    _previousMastery = int.tryParse(uri.queryParameters['previousMastery'] ?? '');
    _currentMastery = int.tryParse(uri.queryParameters['currentMastery'] ?? '');
    _skillName = uri.queryParameters['skillName'];
    _skillId = uri.queryParameters['skillId'];
    _sessionId = uri.queryParameters['sessionId'];
    
    // Also try to get from extra (if passed via context.push with extra parameter)
    final extra = routerState.extra;
    if (extra is Map<String, dynamic>) {
      _totalQuestions ??= extra['totalQuestions'] as int?;
      _correctCount ??= extra['correctCount'] as int?;
      _wrongCount ??= extra['wrongCount'] as int?;
      _previousMastery ??= extra['previousMastery'] as int?;
      _currentMastery ??= extra['currentMastery'] as int?;
      _skillName ??= extra['skillName'] as String?;
      _skillId ??= extra['skillId'] as String?;
      _sessionId ??= extra['sessionId'] as String?;
    }
    
    // Set defaults if not provided
    _totalQuestions ??= 8;
    _correctCount ??= 0;
    _wrongCount ??= 0;
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accuracy = (_totalQuestions ?? 0) > 0
        ? ((_correctCount ?? 0) / (_totalQuestions ?? 1) * 100).toInt()
        : 0;
    final masteryChange = _previousMastery != null && _currentMastery != null
        ? _currentMastery! - _previousMastery!
        : null;
    final masteryLevel = _currentMastery ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const HeadingSmallText('Hoàn thành'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Celebration
            Center(
              child: AnimatedBuilder(
                animation: _celebrationAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _celebrationAnimation.value,
                    child: const Icon(
                      Icons.celebration,
                      size: 80,
                      color: Color(0xFFFF9800),
                    ),
                  );
                },
              ),
            ),

            Gap(context.spacing.s16),

            // Title
            Center(
              child: Text(
                'Hoàn thành session!',
                style: context.textStyle.headingLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Gap(context.spacing.s24),

            // Stats Cards (2x2 Grid)
            _buildStatsGrid(context, accuracy),

            Gap(context.spacing.s24),

            // Mastery Improvement
                    if (masteryChange != null && masteryChange != 0) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(context.padding.p16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mastery tăng: ${_previousMastery}% → ${_currentMastery}% (+$masteryChange%)',
                        style: context.textStyle.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(context.spacing.s12),
                      MasteryProgressBar(
                        currentMastery: _currentMastery!,
                        previousMastery: _previousMastery,
                        height: 12,
                      ),
                      Gap(context.spacing.s8),
                      Text(
                        'Bạn đã cải thiện rất nhiều!',
                        style: context.textStyle.bodySmall.copyWith(
                          color: const Color(0xFF4CAF50),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(context.spacing.s24),
            ],

            // Skill Status
            if (_skillName != null) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(context.padding.p16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _skillName!,
                              style: context.textStyle.body.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Gap(context.spacing.s4),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.padding.p8,
                                vertical: context.padding.p4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9800).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFFF9800),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _getSkillStatus(masteryLevel),
                                style: context.textStyle.bodySmall.copyWith(
                                  color: const Color(0xFFFF9800),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(context.spacing.s24),
            ],

            // Session Persistence Note
            Card(
              color: const Color(0xFFE8F5E9),
              child: Padding(
                padding: EdgeInsets.all(context.padding.p16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF4CAF50),
                    ),
                    Gap(context.spacing.s12),
                    Expanded(
                      child: Text(
                        'Tiến độ đã được lưu. Bạn có thể tiếp tục sau!',
                        style: context.textStyle.bodySmall.copyWith(
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Gap(context.spacing.s24),

            // Recommendations
            _buildRecommendations(context, masteryLevel, accuracy),

            Gap(context.spacing.s24),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (masteryLevel >= 70) {
                    // Navigate to Mini Test
                    context.push(Routes.miniTestStart);
                  } else {
                    // Navigate to more practice
                    if (_skillId != null) {
                      context.push(
                        '${Routes.practiceQuestion}?skillId=$_skillId',
                      );
                    } else {
                      context.push(Routes.skillSelection);
                    }
                  }
                },
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: context.padding.p12),
                  minimumSize: const Size(0, 56),
                ),
                child: Text(
                  masteryLevel >= 70 ? 'Làm Mini Test' : 'Làm thêm bài',
                ),
              ),
            ),

            Gap(context.spacing.s12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  context.go(Routes.todayLearningPlan);
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: context.padding.p12),
                  minimumSize: const Size(0, 48),
                ),
                child: const Text('Về trang chủ'),
              ),
            ),

            if ((_wrongCount ?? 0) > 0) ...[
              Gap(context.spacing.s12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to review wrong answers
                    // TODO: Implement review screen
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: context.padding.p12),
                    minimumSize: const Size(0, 48),
                  ),
                  child: const Text('Xem lại bài làm'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, int accuracy) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: context.spacing.s8,
      mainAxisSpacing: context.spacing.s8,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context,
          '${_totalQuestions ?? 0}/${_totalQuestions ?? 0} câu đã làm',
          Icons.checklist,
          const Color(0xFF2196F3),
        ),
        _buildStatCard(
          context,
          'Đúng: ${_correctCount ?? 0} câu',
          Icons.check_circle,
          const Color(0xFF4CAF50),
        ),
        _buildStatCard(
          context,
          'Sai: ${_wrongCount ?? 0} câu',
          Icons.cancel,
          const Color(0xFFF44336),
        ),
        _buildStatCard(
          context,
          'Tỉ lệ: $accuracy%',
          Icons.bar_chart,
          const Color(0xFFFF9800),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            Gap(context.spacing.s8),
            Text(
              label,
              style: context.textStyle.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations(BuildContext context, int masteryLevel, int accuracy) {
    String recommendation;
    IconData icon;
    Color color;

    if (masteryLevel >= 70) {
      recommendation = '🎯 Sẵn sàng cho Mini Test!';
      icon = Icons.quiz;
      color = const Color(0xFF4CAF50);
    } else if (masteryLevel < 70 && (_totalQuestions ?? 0) >= 8) {
      recommendation = 'Bạn đã làm đủ bài! Hãy làm Mini Test để kiểm tra kiến thức';
      icon = Icons.quiz;
      color = const Color(0xFF2196F3);
    } else {
      final remaining = (70 - masteryLevel) ~/ 5;
      recommendation = 'Làm thêm $remaining bài để đạt 70%';
      icon = Icons.school;
      color = const Color(0xFFFF9800);
    }

    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(context.padding.p16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            Gap(context.spacing.s12),
            Expanded(
              child: Text(
                recommendation,
                style: context.textStyle.body.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSkillStatus(int mastery) {
    if (mastery >= 90) {
      return 'Thành thạo';
    } else if (mastery >= 70) {
      return 'Đang cải thiện';
    } else if (mastery >= 40) {
      return 'Chưa vững';
    } else {
      return 'Yếu';
    }
  }
}

