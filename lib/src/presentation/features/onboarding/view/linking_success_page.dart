import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../riverpod/trial_provider.dart';

class LinkingSuccessPage extends ConsumerStatefulWidget {
  const LinkingSuccessPage({super.key});

  @override
  ConsumerState<LinkingSuccessPage> createState() =>
      _LinkingSuccessPageState();
}

class _LinkingSuccessPageState extends ConsumerState<LinkingSuccessPage> {
  String? _username;
  String? _password;
  String? _dashboardLink;
  int _totalExercises = 0;
  int _skillsLearned = 0;
  int _streakDays = 0;

  @override
  void initState() {
    super.initState();
    // Get data from route parameters
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = GoRouterState.of(context).uri;
      setState(() {
        _username = uri.queryParameters['username'] ?? '';
        _password = uri.queryParameters['password'] ?? '';
        _dashboardLink = uri.queryParameters['dashboardLink'] ?? '';
      });
      // Load trial status for achievement data
      _loadTrialStatus();
    });
  }

  Future<void> _loadTrialStatus() async {
    final trialStatus = await ref.read(trialProvider.notifier).getTrialStatus();
    if (trialStatus != null && mounted) {
      setState(() {
        _totalExercises = trialStatus.totalExercises;
        _skillsLearned = trialStatus.skillsLearned;
        _streakDays = trialStatus.daysUsed;
      });
    }
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.locale.onboarding_linking_success_copy_success(label)),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.padding.p24),
          child: Column(
            children: [
              Gap(context.spacing.s48),
              // Success icon
              Semantics(
                label: context.locale.onboarding_linking_success_title,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              Gap(context.spacing.s24),
              // Title
              Text(
                context.locale.onboarding_linking_success_title,
                textAlign: TextAlign.center,
                style: context.textStyle.headingLarge.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.33, // 32px / 24px
                  color: const Color(0xFF212121),
                ),
              ),
              Gap(context.spacing.s16),
              // Description
              Text(
                context.locale.onboarding_linking_success_description,
                textAlign: TextAlign.center,
                style: context.textStyle.bodyLarge.copyWith(
                  fontSize: 16,
                  height: 1.5, // 24px / 16px
                  color: const Color(0xFF757575),
                ),
              ),
              Gap(context.spacing.s32),
              // Data preservation note
              Container(
                padding: EdgeInsets.all(context.padding.p16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.locale.onboarding_linking_success_data_saved_title,
                      style: context.textStyle.bodyMedium.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.43, // 20px / 14px
                        color: const Color(0xFF212121),
                      ),
                    ),
                    Gap(context.spacing.s8),
                    Row(
                      children: [
                        Expanded(
                          child: _DataItem(
                            icon: '📚',
                            value: '$_totalExercises',
                            label: context.locale.onboarding_linking_success_data_exercises,
                          ),
                        ),
                        Expanded(
                          child: _DataItem(
                            icon: '🎯',
                            value: '$_skillsLearned',
                            label: context.locale.onboarding_linking_success_data_skills,
                          ),
                        ),
                        Expanded(
                          child: _DataItem(
                            icon: '🔥',
                            value: '$_streakDays',
                            label: context.locale.onboarding_linking_success_data_days,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(context.spacing.s24),
              // Information card
              Semantics(
                label: context.locale.onboarding_linking_success_parent_info_title,
                child: Container(
                  padding: EdgeInsets.all(context.padding.p16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.locale.onboarding_linking_success_parent_info_title,
                      style: context.textStyle.bodyMedium.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.43, // 20px / 14px
                        color: const Color(0xFF212121),
                      ),
                      ),
                      Gap(context.spacing.s16),
                      // Username
                      if (_username != null && _username!.isNotEmpty)
                        _InfoField(
                          label: context.locale.onboarding_linking_success_parent_username_label,
                          value: _username!,
                          onCopy: () => _copyToClipboard(
                            context,
                            _username!,
                            context.locale.onboarding_linking_success_parent_username_label.replaceFirst(': ', ''),
                          ),
                        ),
                      if (_username != null && _username!.isNotEmpty)
                        Gap(context.spacing.s12),
                      // Password
                      if (_password != null && _password!.isNotEmpty) ...[
                        _InfoField(
                          label: context.locale.onboarding_linking_success_parent_password_label,
                          value: _password!,
                          onCopy: () => _copyToClipboard(
                            context,
                            _password!,
                            context.locale.onboarding_linking_success_parent_password_label.replaceFirst(': ', ''),
                          ),
                        ),
                        Gap(context.spacing.s8),
                        Text(
                          context.locale.onboarding_linking_success_parent_password_note,
                          style: context.textStyle.bodySmall.copyWith(
                            fontSize: 12,
                            height: 1.33, // 16px / 12px
                            color: const Color(0xFFFF9800),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Gap(context.spacing.s16),
                      ],
                      // Dashboard link
                      if (_dashboardLink != null && _dashboardLink!.isNotEmpty)
                        _InfoField(
                          label: context.locale.onboarding_linking_success_parent_dashboard_label,
                          value: _dashboardLink!,
                          onCopy: () => _copyToClipboard(
                            context,
                            _dashboardLink!,
                            context.locale.onboarding_linking_success_parent_dashboard_label.replaceFirst(': ', ''),
                          ),
                          isLink: true,
                        ),
                    ],
                  ),
                ),
              ),
              Gap(context.spacing.s32),
              // Complete button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    context.go(Routes.home);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    context.locale.onboarding_linking_success_button_complete,
                    style: context.textStyle.bodyLarge.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Gap(context.spacing.s32),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataItem extends StatelessWidget {
  const _DataItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final String icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 24),
        ),
        Gap(context.spacing.s4),
        Text(
          value,
          style: context.textStyle.headingMedium.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.33, // 24px / 18px
            color: const Color(0xFF212121),
          ),
        ),
        Text(
          label,
          style: context.textStyle.bodySmall.copyWith(
            fontSize: 12,
            height: 1.33, // 16px / 12px
            color: const Color(0xFF757575),
          ),
        ),
      ],
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.label,
    required this.value,
    required this.onCopy,
    this.isLink = false,
  });

  final String label;
  final String value;
  final VoidCallback onCopy;
  final bool isLink;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
                        style: context.textStyle.bodyMedium.copyWith(
                          fontSize: 12,
                          height: 1.33, // 16px / 12px
                          color: const Color(0xFF757575),
                        ),
        ),
        Gap(context.spacing.s4),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.padding.p12,
                  vertical: context.padding.p8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                child: Text(
                  value,
                  style: context.textStyle.bodyMedium.copyWith(
                    fontSize: 14,
                    height: 1.43, // 20px / 14px
                    fontFamily: 'monospace',
                    color: const Color(0xFF212121),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Gap(context.spacing.s8),
              Semantics(
              label: context.locale.onboarding_linking_success_copy_success(label),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onCopy,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.copy,
                      size: 20,
                      color: Color(0xFF757575),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

