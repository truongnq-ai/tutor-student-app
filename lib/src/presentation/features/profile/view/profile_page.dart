import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock: Check if trial < 2 days
    // In real implementation, this would check from trial provider
    final daysRemaining = 1; // Mock value
    final showWarning = daysRemaining < 2;

    return Scaffold(
      appBar: AppBar(
        title: const HeadingSmallText('Hồ sơ'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Thông tin cá nhân'),
            onTap: () {
              // Navigate to personal info
            },
          ),
          ListTile(
            leading: Stack(
              children: [
                const Icon(Icons.calendar_today),
                if (showWarning)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF9800),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            title: const Text('Trạng thái dùng thử'),
            subtitle: showWarning
                ? const Text(
                    'Còn ít hơn 2 ngày',
                    style: TextStyle(color: Color(0xFFFF9800)),
                  )
                : null,
            trailing: showWarning
                ? const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFFF9800),
                  )
                : const Icon(Icons.chevron_right),
            onTap: () {
              context.pushNamed(Routes.trialStatus);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Cài đặt'),
            onTap: () {
              // Navigate to settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Đăng xuất'),
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }
}
