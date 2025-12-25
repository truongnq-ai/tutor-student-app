import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/text/typography.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: HeadingSmallText(context.locale.auth_reset_password_title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.padding.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(context.spacing.s16),
              BodyMediumText.secondary(context.locale.auth_forgot_password_enter_associated_email),
              Gap(context.spacing.s16),
              BodyMediumText(context.locale.common_field_email_address),
              Gap(context.spacing.s8),
              TextFormField(
                decoration: InputDecoration(hintText: context.locale.common_field_email),
              ),
              Gap(context.spacing.s16),
              FilledButton(
                onPressed: () {
                  context.pushReplacementNamed(Routes.emailVerification);
                },
                child: Text(context.locale.common_button_continue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
