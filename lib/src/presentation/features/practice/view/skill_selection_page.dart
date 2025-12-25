import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/weak_skill_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/weak_skills_provider.dart';
import '../widgets/skill_card.dart';

class SkillSelectionPage extends ConsumerStatefulWidget {
  const SkillSelectionPage({super.key});

  @override
  ConsumerState<SkillSelectionPage> createState() => _SkillSelectionPageState();
}

class _SkillSelectionPageState extends ConsumerState<SkillSelectionPage> {
  String? _selectedSkillId;
  String? _selectedSkillName;

  @override
  Widget build(BuildContext context) {
    final weakSkillsState = ref.watch(weakSkillsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const HeadingSmallText('Chọn kỹ năng để luyện tập'),
      ),
      body: weakSkillsState.when(
        data: (weakSkills) {
          if (weakSkills.isEmpty) {
            return _buildEmptyState(context, 'Không có skill yếu. Tuyệt vời!');
          }
          return _buildContent(context, weakSkills);
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stackTrace) => _buildErrorState(context, error),
      ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildContent(BuildContext context, List<WeakSkillEntity> weakSkills) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.padding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bạn có thể chọn một trong các kỹ năng sau để cải thiện',
            style: context.textStyle.body.copyWith(
              color: context.color.textSecondary,
            ),
          ),
          Gap(context.spacing.s24),

          // Skill cards from API
          ...weakSkills.map((skill) => Padding(
                padding: EdgeInsets.only(bottom: context.spacing.s12),
                child: SkillCard(
                  skillName: skill.skillName,
                  masteryLevel: skill.masteryLevel,
                  status: skill.status == 'weak' ? 'Yếu' : 'Chưa vững',
                  questionCount: skill.questionCount,
                  estimatedTime: '~${skill.estimatedTimeMinutes} phút',
                  isSelected: _selectedSkillId == skill.skillId,
                  isPriority: skill.isPriority,
                  onTap: () {
                    setState(() {
                      _selectedSkillId = skill.skillId;
                      _selectedSkillName = skill.skillName;
                    });
                  },
                ),
              )),

          Gap(context.spacing.s24),

          // Info card
          Card(
            color: const Color(0xFFE3F2FD),
            child: Padding(
              padding: EdgeInsets.all(context.padding.p16),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF2196F3)),
                  Gap(context.spacing.s12),
                  Expanded(
                    child: Text(
                      'Chọn một kỹ năng để bắt đầu luyện tập. Hệ thống sẽ tạo bài tập phù hợp với trình độ của bạn.',
                      style: context.textStyle.bodySmall.copyWith(
                        color: const Color(0xFF2196F3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.padding.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: _selectedSkillId != null
              ? () {
                  // Navigate to practice question with selected skill
                  context.push(
                    '${Routes.practiceQuestion}?skillId=$_selectedSkillId&skillName=$_selectedSkillName',
                  );
                }
              : null,
          style: FilledButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: context.padding.p12),
            minimumSize: const Size(0, 56),
          ),
          child: const Text('Bắt đầu học'),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 64, color: Color(0xFF4CAF50)),
            Gap(context.spacing.s16),
            Text(
              message,
              style: context.textStyle.headingSmall,
              textAlign: TextAlign.center,
            ),
            Gap(context.spacing.s24),
            FilledButton(
              onPressed: () => context.go(Routes.todayLearningPlan),
              child: const Text('Về trang chủ'),
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
              'Không thể tải danh sách kỹ năng',
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
                ref.read(weakSkillsProvider.notifier).refresh();
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

