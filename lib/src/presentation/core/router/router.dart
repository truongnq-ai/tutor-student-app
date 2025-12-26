import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/extensions/riverpod_extensions.dart';
import '../../../core/logger/log.dart';
import '../../features/authentication/forgot_password/view/create_new_password_page.dart';
import '../../features/authentication/forgot_password/view/email_verification_page.dart';
import '../../features/authentication/forgot_password/view/reset_password_page.dart';
import '../../features/authentication/forgot_password/view/reset_password_success_page.dart';
import '../../features/authentication/login/view/login_page.dart';
import '../../features/authentication/registration/view/registration_page.dart';
import '../../features/authentication/view/auth_entry_page.dart';
import '../../features/home/view/home_page.dart';
import '../../features/onboarding/view/linking_success_page.dart';
import '../../features/onboarding/view/onboarding_page.dart';
import '../../features/onboarding/view/otp_verification_page.dart';
import '../../features/onboarding/view/select_grade_page.dart';
import '../../features/onboarding/view/select_learning_goal_page.dart';
import '../../features/onboarding/view/trial_expiry_page.dart';
import '../../features/onboarding/view/trial_start_page.dart';
import '../../features/onboarding/view/trial_status_page.dart';
import '../../features/onboarding/view/welcome_page.dart';
import '../../features/profile/view/profile_overview_page.dart';
import '../../features/profile/view/edit_profile_page.dart';
import '../../features/profile/view/settings_page.dart';
import '../../features/profile/view/change_password_page.dart';
import '../../features/profile/view/about_help_page.dart';
import '../../features/splash/view/splash_page.dart';
import '../widgets/app_startup/startup_widget.dart';
import '../widgets/navigation_shell.dart';
import '../../features/authentication/oauth/view/set_credential_page.dart';
import '../../features/learning/view/today_learning_plan_page.dart';
import '../../features/practice/view/practice_history_page.dart';
import '../../features/practice/view/practice_question_page.dart';
import '../../features/practice/view/practice_result_page.dart';
import '../../features/practice/view/practice_session_complete_page.dart';
import '../../features/practice/view/session_resume_page.dart';
import '../../features/practice/view/skill_selection_page.dart';
import '../../features/tutor/view/camera_capture_page.dart';
import '../../features/tutor/view/ocr_confirmation_page.dart';
import '../../features/tutor/view/recent_problems_list_page.dart';
import '../../features/tutor/view/solution_step_by_step_page.dart';
import '../../features/tutor/view/text_input_page.dart';
import '../../features/tutor/view/tutor_mode_entry_page.dart';
import '../../features/progress/view/progress_dashboard_page.dart';
import '../../features/progress/view/skill_detail_page.dart';
import '../../features/progress/view/mini_test_start_page.dart';
import '../../features/progress/view/mini_test_question_page.dart';
import '../../features/progress/view/mini_test_result_page.dart';
import '../../features/progress/view/recommendations_page.dart';
import 'router_state/router_state_provider.dart';
import 'routes.dart';

part 'parts/authentication_routes.dart';
part 'parts/on_boarding_routes.dart';
part 'parts/learning_routes.dart';
part 'parts/tutor_routes.dart';
part 'parts/progress_routes.dart';
part 'parts/profile_routes.dart';
part 'parts/shell_routes.dart';
part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Root');

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    refreshListenable: ref.asListenable(routerStateProvider),
    initialLocation: Routes.initial,
    redirect: (context, state) {
      Log.info('Redirecting to ${state.uri}');
      if ([
        Routes.initial,
        Routes.onboarding,
        Routes.splash,
        Routes.welcome,
      ].contains(state.uri.path)) {
        return ref.asListenable(routerStateProvider).value;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.initial,
        name: Routes.initial,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: AppStartupWidget(
              loading: SplashPage(),
              loaded: SplashPage(),
            ),
          );
        },
      ),
      ..._onboardingRoutes(ref),
      ..._authenticationRoutes(ref),
      ..._learningRoutes(ref),
      ..._tutorRoutes(ref),
      ..._progressRoutes(ref),
      ..._profileRoutes(ref),
      _shellRoutes(ref),
    ],
  );
}
