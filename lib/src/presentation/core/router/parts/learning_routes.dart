part of '../router.dart';

List<GoRoute> _learningRoutes(Ref ref) {
  return [
    // Today's Learning Plan
    GoRoute(
      path: Routes.todayLearningPlan,
      name: Routes.todayLearningPlan,
      pageBuilder: (context, state) {
        return const MaterialPage(child: TodayLearningPlanPage());
      },
    ),
    // Practice Question
    GoRoute(
      path: Routes.practiceQuestion,
      name: Routes.practiceQuestion,
      pageBuilder: (context, state) {
        final skillId = state.uri.queryParameters['skillId'];
        final questionNumber = int.tryParse(state.uri.queryParameters['questionNumber'] ?? '');
        final totalQuestions = int.tryParse(state.uri.queryParameters['totalQuestions'] ?? '');
        final sessionId = state.uri.queryParameters['sessionId'];
        return MaterialPage(
          child: PracticeQuestionPage(
            skillId: skillId,
            questionNumber: questionNumber,
            totalQuestions: totalQuestions,
            sessionId: sessionId,
          ),
        );
      },
    ),
    // Practice Result
    GoRoute(
      path: Routes.practiceResult,
      name: Routes.practiceResult,
      pageBuilder: (context, state) {
        final questionId = state.uri.queryParameters['questionId'] ?? '';
        final isCorrect = state.uri.queryParameters['isCorrect'] == 'true';
        final questionNumber = int.tryParse(state.uri.queryParameters['questionNumber'] ?? '');
        final totalQuestions = int.tryParse(state.uri.queryParameters['totalQuestions'] ?? '');
        final sessionId = state.uri.queryParameters['sessionId'];
        return MaterialPage(
          child: PracticeResultPage(
            questionId: questionId,
            isCorrect: isCorrect,
            questionNumber: questionNumber,
            totalQuestions: totalQuestions,
            sessionId: sessionId,
          ),
        );
      },
    ),
    // Practice Session Complete
    GoRoute(
      path: Routes.practiceSessionComplete,
      name: Routes.practiceSessionComplete,
      pageBuilder: (context, state) {
        return const MaterialPage(child: PracticeSessionCompletePage());
      },
    ),
    // Skill Selection
    GoRoute(
      path: Routes.skillSelection,
      name: Routes.skillSelection,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SkillSelectionPage());
      },
    ),
    // Practice History
    GoRoute(
      path: Routes.practiceHistory,
      name: Routes.practiceHistory,
      pageBuilder: (context, state) {
        return const MaterialPage(child: PracticeHistoryPage());
      },
    ),
    // Session Resume
    GoRoute(
      path: Routes.sessionResume,
      name: Routes.sessionResume,
      pageBuilder: (context, state) {
        final sessionId = state.uri.queryParameters['sessionId'];
        final skillId = state.uri.queryParameters['skillId'];
        final skillName = state.uri.queryParameters['skillName'];
        return MaterialPage(
          child: SessionResumePage(
            sessionId: sessionId,
            skillId: skillId,
            skillName: skillName,
          ),
        );
      },
    ),
  ];
}

