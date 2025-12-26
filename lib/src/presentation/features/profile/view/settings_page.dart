import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/settings_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/router/routes.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/settings_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsProvider.notifier).loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: HeadingSmallText('Cài đặt'),
      ),
      body: settingsState.when(
        data: (settings) {
          if (settings == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildContent(context, settings);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SettingsEntity settings) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.padding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notifications Section
          _buildSectionTitle(context, 'Thông báo'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Thông báo đẩy'),
                  subtitle: const Text('Nhận thông báo từ ứng dụng'),
                  value: settings.notificationPush,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).updateSettings(
                          notificationPush: value,
                        );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Nhắc nhở học tập'),
                  subtitle: const Text('Nhận thông báo nhắc nhở học tập'),
                  value: settings.notificationLearningReminder,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).updateSettings(
                          notificationLearningReminder: value,
                        );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Thông báo tiến độ'),
                  subtitle: const Text('Nhận thông báo về tiến độ học tập'),
                  value: settings.notificationProgress,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).updateSettings(
                          notificationProgress: value,
                        );
                  },
                ),
              ],
            ),
          ),
          Gap(context.spacing.s24),

          // Learning Section
          _buildSectionTitle(context, 'Học tập'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Hiển thị thống kê chi tiết'),
                  subtitle: const Text('Hiển thị thống kê chi tiết trong bảng điều khiển'),
                  value: settings.showDetailedStats,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).updateSettings(
                          showDetailedStats: value,
                        );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Chế độ luyện tập'),
                  subtitle: const Text('Chọn cách luyện tập'),
                  trailing: DropdownButton<String>(
                    value: settings.practiceMode,
                    items: const [
                      DropdownMenuItem(value: 'auto', child: Text('Tự động')),
                      DropdownMenuItem(value: 'manual', child: Text('Thủ công')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(settingsProvider.notifier).updateSettings(
                              practiceMode: value,
                            );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Gap(context.spacing.s24),

          // App Section
          _buildSectionTitle(context, 'Ứng dụng'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Ngôn ngữ'),
                  subtitle: const Text('Tiếng Việt'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Language selection
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Phiên bản'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Dung lượng cache'),
                  subtitle: const Text('Đang tính toán...'),
                  trailing: TextButton(
                    onPressed: () {
                      // TODO: Clear cache
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã xóa cache')),
                      );
                    },
                    child: const Text('Xóa'),
                  ),
                ),
              ],
            ),
          ),
          Gap(context.spacing.s24),

          // Account Section
          _buildSectionTitle(context, 'Tài khoản'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Đổi mật khẩu'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.pushNamed(Routes.profileChangePassword);
                  },
                ),
              ],
            ),
          ),
          Gap(context.spacing.s24),

          // Info Section
          _buildSectionTitle(context, 'Thông tin'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Về ứng dụng'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.pushNamed(Routes.profileAboutHelp);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Điều khoản sử dụng'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Open terms
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Chính sách bảo mật'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Open privacy
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.contact_support),
                  title: const Text('Liên hệ hỗ trợ'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Contact support
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.padding.p8),
      child: BodyLargeText(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

