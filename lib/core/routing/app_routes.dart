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

  // ─── Programmes ──────────────────────────
  static const String programs = "/programs";
  static const String programNew = "/programs/new";
  static const String programDetail = "/programs/:id";
  static String programDetailPath(String id) => "/programs/$id";
  static const String programEdit = "/programs/:id/edit";
  static String programEditPath(String id) => "/programs/$id/edit";
}
