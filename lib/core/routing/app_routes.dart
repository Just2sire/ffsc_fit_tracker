/// Chemins de routes FitTracker.
class AppRoutes {
  AppRoutes._();

  // ─── Racine & onboarding ───────────────────
  static const String root = "/";
  static const String onboarding = "/onboarding";

  // ─── Onglets shell (4 branches) ───────────
  static const String home = "/home";
  static const String exercises = "/exercises";
  static const String history = "/history";
  static const String profile = "/profile";

  // ─── Exercices ───────────────────────────
  static String exerciseDetailPath(String id) => "/exercises/$id";
  static const String exerciseDetail = "/exercises/:id";


}
