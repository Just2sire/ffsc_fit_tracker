import "package:flutter/widgets.dart";
import "package:go_router/go_router.dart";

import "../routing/app_routes.dart";

/// Extensions de navigation FitTracker — enveloppent GoRouter avec les vraies
/// destinations métier de l'app.
extension NavigationExtensions on BuildContext {
  // ─── Racine & Onboarding ────────────────────

  void goRoot() => go(AppRoutes.root);
  void goOnboarding() => go(AppRoutes.onboarding);

  // ─── Onglets ──────────────────────────────

  void goHome() => go(AppRoutes.home);
  void goExercises() => go(AppRoutes.exercises);
  void goHistory() => go(AppRoutes.history);
  void goProfile() => go(AppRoutes.profile);

  // ─── Retour ───────────────────────────────

  void popScreen<T extends Object?>([T? result]) {
    if (canPop()) pop<T>(result);
  }
}

/// Extensions de navigation impérative sur le GoRouter.
extension GoRouterExtension on GoRouter {
  void goAndClearStack(String location) {
    while (canPop()) {
      pop();
    }
    go(location);
  }

  Future<T?> pushWithResult<T>(String location, {Object? extra}) {
    return push<T>(location, extra: extra);
  }
}
