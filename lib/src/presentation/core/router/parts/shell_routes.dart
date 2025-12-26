part of '../router.dart';

StatefulShellRoute _shellRoutes(Ref ref) {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return NavigationShell(statefulNavigationShell: navigationShell);
    },
    branches: [
      // Home branch (index 0)
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.home,
            name: Routes.home,
            pageBuilder: (context, state) {
              return const MaterialPage(child: HomePage());
            },
          ),
        ],
      ),
      // Practice branch (index 1)
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.skillSelection,
            name: Routes.skillSelection,
            pageBuilder: (context, state) {
              return const MaterialPage(child: SkillSelectionPage());
            },
          ),
        ],
      ),
      // Tutor branch (index 2)
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.tutorModeEntry,
            name: Routes.tutorModeEntry,
            pageBuilder: (context, state) {
              return const MaterialPage(child: TutorModeEntryPage());
            },
          ),
        ],
      ),
      // Profile branch (index 3)
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.profile,
            name: Routes.profile,
            pageBuilder: (context, state) {
              return const MaterialPage(child: ProfileOverviewPage());
            },
          ),
        ],
      ),
    ],
  );
}
