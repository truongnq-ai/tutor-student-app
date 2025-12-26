part of '../router.dart';

List<RouteBase> _profileRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.profileEdit,
      name: Routes.profileEdit,
      pageBuilder: (context, state) {
        return const MaterialPage(child: EditProfilePage());
      },
    ),
    GoRoute(
      path: Routes.profileSettings,
      name: Routes.profileSettings,
      pageBuilder: (context, state) {
        return const MaterialPage(child: SettingsPage());
      },
    ),
    GoRoute(
      path: Routes.profileChangePassword,
      name: Routes.profileChangePassword,
      pageBuilder: (context, state) {
        return const MaterialPage(child: ChangePasswordPage());
      },
    ),
    GoRoute(
      path: Routes.profileAboutHelp,
      name: Routes.profileAboutHelp,
      pageBuilder: (context, state) {
        return const MaterialPage(child: AboutHelpPage());
      },
    ),
  ];
}

