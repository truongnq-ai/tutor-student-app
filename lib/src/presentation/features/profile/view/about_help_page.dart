import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class AboutHelpPage extends StatefulWidget {
  const AboutHelpPage({super.key});

  @override
  State<AboutHelpPage> createState() => _AboutHelpPageState();
}

class _AboutHelpPageState extends State<AboutHelpPage> {
  final Map<String, bool> _expandedFAQs = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadingSmallText('Giúp đỡ & Hỗ trợ'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.padding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // About Section
            _buildSectionTitle(context, 'Về ứng dụng'),
            Card(
              child: Padding(
                padding: EdgeInsets.all(context.padding.p16),
                child: Column(
                  children: [
                    // Logo placeholder
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.school, size: 40, color: Colors.white),
                    ),
                    Gap(context.spacing.s16),
                    BodyLargeText(
                      'Tutor App',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Gap(context.spacing.s4),
                    BodySmallText(
                      'Ứng dụng học tập thông minh',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Gap(context.spacing.s8),
                    BodySmallText(
                      'Phiên bản 1.0.0',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Gap(context.spacing.s16),
                    BodySmallText(
                      'Tutor App là ứng dụng học tập giúp học sinh cải thiện kỹ năng toán học thông qua luyện tập thông minh và giải bài tập chi tiết.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            Gap(context.spacing.s24),

            // FAQ Section
            _buildSectionTitle(context, 'Câu hỏi thường gặp'),
            Card(
              child: Column(
                children: [
                  _buildFAQItem(
                    context,
                    'Làm thế nào để bắt đầu học?',
                    'Bạn có thể bắt đầu bằng cách chọn một kỹ năng từ trang chủ và bắt đầu luyện tập. Hệ thống sẽ tự động điều chỉnh độ khó dựa trên trình độ của bạn.',
                  ),
                  const Divider(height: 1),
                  _buildFAQItem(
                    context,
                    'Làm thế nào để nâng cao điểm số?',
                    'Hãy luyện tập thường xuyên và hoàn thành các bài tập được gợi ý. Hệ thống sẽ theo dõi tiến độ và đề xuất các kỹ năng cần cải thiện.',
                  ),
                  const Divider(height: 1),
                  _buildFAQItem(
                    context,
                    'Tôi có thể sử dụng ứng dụng miễn phí không?',
                    'Ứng dụng cung cấp gói dùng thử miễn phí. Sau đó, bạn có thể đăng ký gói trả phí để tiếp tục sử dụng đầy đủ tính năng.',
                  ),
                  const Divider(height: 1),
                  _buildFAQItem(
                    context,
                    'Làm thế nào để liên kết với phụ huynh?',
                    'Bạn có thể liên kết tài khoản với phụ huynh thông qua số điện thoại. Phụ huynh sẽ nhận được mã OTP để xác nhận.',
                  ),
                ],
              ),
            ),
            Gap(context.spacing.s24),

            // Help Section
            _buildSectionTitle(context, 'Hướng dẫn'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.book),
                    title: const Text('Hướng dẫn sử dụng'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Open usage guide
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.video_library),
                    title: const Text('Video hướng dẫn'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Open video tutorial
                    },
                  ),
                ],
              ),
            ),
            Gap(context.spacing.s24),

            // Contact Section
            _buildSectionTitle(context, 'Liên hệ'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: const Text('support@tutorapp.com'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final uri = Uri.parse('mailto:support@tutorapp.com');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Hotline'),
                    subtitle: const Text('1900-xxxx'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final uri = Uri.parse('tel:1900xxxx');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    },
                  ),
                ],
              ),
            ),
            Gap(context.spacing.s24),

            // Legal Section
            _buildSectionTitle(context, 'Pháp lý'),
            Card(
              child: Column(
                children: [
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
                    leading: const Icon(Icons.info),
                    title: const Text('Giấy phép'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Open license
                    },
                  ),
                ],
              ),
            ),
            Gap(context.spacing.s24),

            // Footer
            Center(
              child: BodySmallText(
                '© 2025 Tutor App. All rights reserved.',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
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

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    final isExpanded = _expandedFAQs[question] ?? false;

    return ExpansionTile(
      title: Text(question),
      initiallyExpanded: isExpanded,
      onExpansionChanged: (expanded) {
        setState(() {
          _expandedFAQs[question] = expanded;
        });
      },
      children: [
        Padding(
          padding: EdgeInsets.all(context.padding.p16),
          child: Text(
            answer,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}

