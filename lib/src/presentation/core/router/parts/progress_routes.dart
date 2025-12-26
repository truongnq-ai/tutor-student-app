part of '../router.dart';

List<GoRoute> _progressRoutes(Ref ref) {
  return [
    // Progress Dashboard
    GoRoute(
      path: Routes.progressDashboard,
      name: Routes.progressDashboard,
      pageBuilder: (context, state) {
        return const MaterialPage(child: ProgressDashboardPage());
      },
    ),
    // Progress Skill Detail
    GoRoute(
      path: Routes.progressSkillDetail,
      name: Routes.progressSkillDetail,
      pageBuilder: (context, state) {
        final skillId = state.uri.queryParameters['skillId'];
        return MaterialPage(
          child: SkillDetailPage(skillId: skillId),
        );
      },
    ),
    // Progress Recommendations
    GoRoute(
      path: Routes.progressRecommendations,
      name: Routes.progressRecommendations,
      pageBuilder: (context, state) {
        return const MaterialPage(
          child: RecommendationsPage(),
        );
      },
    ),
    // Mini Test Start
    GoRoute(
      path: Routes.miniTestStart,
      name: Routes.miniTestStart,
      pageBuilder: (context, state) {
        final skillId = state.uri.queryParameters['skillId'];
        return MaterialPage(
          child: MiniTestStartPage(skillId: skillId),
        );
      },
    ),
    // Mini Test Question
    GoRoute(
      path: Routes.miniTestQuestion,
      name: Routes.miniTestQuestion,
      pageBuilder: (context, state) {
        final sessionId = state.uri.queryParameters['sessionId'];
        return MaterialPage(
          child: MiniTestQuestionPage(sessionId: sessionId),
        );
      },
    ),
    // Mini Test Result
    GoRoute(
      path: Routes.miniTestResult,
      name: Routes.miniTestResult,
      pageBuilder: (context, state) {
        final resultId = state.uri.queryParameters['resultId'];
        final sessionId = state.uri.queryParameters['sessionId'];
        return MaterialPage(
          child: MiniTestResultPage(
            resultId: resultId,
            sessionId: sessionId,
          ),
        );
      },
    ),
  ];
}

