import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Reusable OAuth button widget
class OAuthButton extends StatelessWidget {
  const OAuthButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.isLoading = false,
  });

  final String provider; // 'google' or 'apple'
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isGoogle = provider.toLowerCase() == 'google';
    final icon = isGoogle
        ? const Icon(Icons.g_mobiledata, size: 24)
        : const Icon(Icons.apple, size: 24);
    final text = isGoogle ? 'Đăng nhập với Google' : 'Đăng nhập với Apple';
    final color = isGoogle ? Colors.blue : Colors.black;

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        side: BorderSide(color: color),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const Gap(8),
                Text(text),
              ],
            ),
    );
  }
}

