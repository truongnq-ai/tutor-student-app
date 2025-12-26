part of '../router.dart';

List<RouteBase> _tutorRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.tutorModeEntry,
      name: Routes.tutorModeEntry,
      pageBuilder: (context, state) {
        return const MaterialPage(child: TutorModeEntryPage());
      },
    ),
    GoRoute(
      path: Routes.tutorCameraCapture,
      name: Routes.tutorCameraCapture,
      pageBuilder: (context, state) {
        return const MaterialPage(child: CameraCapturePage());
      },
    ),
    GoRoute(
      path: Routes.tutorTextInput,
      name: Routes.tutorTextInput,
      pageBuilder: (context, state) {
        return const MaterialPage(child: TextInputPage());
      },
    ),
    GoRoute(
      path: Routes.tutorOcrConfirmation,
      name: Routes.tutorOcrConfirmation,
      pageBuilder: (context, state) {
        final imageUrl = state.uri.queryParameters['imageUrl'];
        final ocrText = state.uri.queryParameters['ocrText'];
        final confidence = double.tryParse(state.uri.queryParameters['confidence'] ?? '');
        return MaterialPage(
          child: OcrConfirmationPage(
            imageUrl: imageUrl,
            ocrText: ocrText,
            confidence: confidence,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.tutorSolution,
      name: Routes.tutorSolution,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SolutionStepByStepPage());
      },
    ),
    GoRoute(
      path: Routes.tutorSolutionComplete,
      name: Routes.tutorSolutionComplete,
      pageBuilder: (context, state) {
        // Solution Complete is integrated into Solution Step-by-Step at the last step
        // This route can be used for direct navigation if needed
        return const MaterialPage(child: SolutionStepByStepPage());
      },
    ),
    GoRoute(
      path: Routes.tutorRecentProblems,
      name: Routes.tutorRecentProblems,
      pageBuilder: (context, state) {
        return const MaterialPage(child: RecentProblemsListPage());
      },
    ),
  ];
}

