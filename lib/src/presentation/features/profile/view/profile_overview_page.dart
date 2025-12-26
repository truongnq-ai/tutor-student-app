import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/profile_entity.dart';
import '../../../../domain/entities/progress_dashboard_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/widgets/text/typography.dart';
import '../../progress/riverpod/progress_provider.dart';
import '../riverpod/profile_provider.dart';

class ProfileOverviewPage extends ConsumerStatefulWidget {
  const ProfileOverviewPage({super.key});

  @override
  ConsumerState<ProfileOverviewPage> createState() => _ProfileOverviewPageState();
}

class _ProfileOverviewPageState extends ConsumerState<ProfileOverviewPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).loadProfile();
      ref.read(progressDashboardProvider.notifier).loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final dashboardState = ref.watch(progressDashboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: HeadingSmallText(context.locale.profile_title),
      ),
      body: profileState.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildContent(context, profile, dashboardState);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProfileEntity profile,
    AsyncValue<ProgressDashboardEntity?> dashboardState,
  ) {
    final dashboard = dashboardState.valueOrNull;
    
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(profileProvider.notifier).loadProfile();
        await ref.read(progressDashboardProvider.notifier).loadDashboard();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            _buildProfileHeader(context, profile),
            Gap(context.spacing.s24),

            // Stats Cards
            if (dashboard != null) ...[
              _buildStatsSection(context, dashboard),
              Gap(context.spacing.s24),
            ],

            // Menu Items
            _buildMenuSection(context, profile),
            Gap(context.spacing.s24),

            // Account Info
            _buildAccountInfo(context, profile),
            Gap(context.spacing.s24),

            // Logout Button
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileEntity profile) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
              backgroundImage: profile.avatarUrl != null
                  ? CachedNetworkImageProvider(profile.avatarUrl!)
                  : null,
              child: profile.avatarUrl == null
                  ? Icon(Icons.person, size: 40, color: Colors.grey[600])
                  : null,
            ),
            Gap(context.spacing.s16),
            // Name & Username
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyLargeText(
                    profile.name ?? profile.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Gap(context.spacing.s4),
                  BodySmallText(
                    '@${profile.username}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  if (profile.grade != null) ...[
                    Gap(context.spacing.s4),
                    BodySmallText(
                      'Lớp ${profile.grade}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
            // Status Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.padding.p8,
                vertical: context.padding.p4,
              ),
              decoration: BoxDecoration(
                color: profile.status == 'ACTIVE' ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: BodySmallText(
                profile.status == 'ACTIVE' ? 'Hoạt động' : 'Chờ kích hoạt',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, dashboard) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Ngày liên tiếp',
            '${dashboard.streakDays}',
            Icons.local_fire_department,
            Colors.orange,
          ),
        ),
        Gap(context.spacing.s12),
        Expanded(
          child: _buildStatCard(
            context,
            'Tổng bài tập',
            '${dashboard.totalPractices}',
            Icons.assignment,
            Colors.blue,
          ),
        ),
        Gap(context.spacing.s12),
        Expanded(
          child: _buildStatCard(
            context,
            'Độ thành thạo TB',
            '${(dashboard.accuracyRate * 100).toStringAsFixed(0)}%',
            Icons.trending_up,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            Gap(context.spacing.s8),
            BodyLargeText(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            Gap(context.spacing.s4),
            BodySmallText(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, ProfileEntity profile) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Chỉnh sửa hồ sơ'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.pushNamed(Routes.profileEdit);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Cài đặt'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.pushNamed(Routes.profileSettings);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Đổi mật khẩu'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.pushNamed(Routes.profileChangePassword);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Giúp đỡ & Hỗ trợ'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.pushNamed(Routes.profileAboutHelp);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(BuildContext context, ProfileEntity profile) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BodyLargeText(
              'Thông tin tài khoản',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Gap(context.spacing.s12),
            _buildInfoRow(context, 'Tên đăng nhập', profile.username),
            if (profile.email != null)
              _buildInfoRow(context, 'Email', profile.email!),
            _buildInfoRow(
              context,
              'Liên kết phụ huynh',
              profile.parentLinked ? 'Đã liên kết' : 'Chưa liên kết',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.padding.p8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: BodySmallText(
              label,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: BodySmallText(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _showLogoutDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: EdgeInsets.all(context.padding.p16),
        ),
        child: const Text('Đăng xuất'),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout
              // ref.read(authProvider.notifier).logout();
              // context.go(Routes.login);
            },
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

