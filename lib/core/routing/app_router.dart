import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../features/active_session/presentation/pages/active_session_page.dart";
import "../../features/active_session/presentation/pages/session_history_page.dart";
import "../../features/exercise_library/presentation/pages/exercise_detail_page.dart";
import "../../features/exercise_library/presentation/pages/exercise_library_page.dart";
import "../../features/home/presentation/pages/home_page.dart";
import "../../features/programs/presentation/pages/program_detail_page.dart";
import "../../features/programs/presentation/pages/program_editor_page.dart";
import "../../features/programs/presentation/pages/program_list_page.dart";
import "../../shared/presentation/pages/welcome_page.dart";
import "../../shared/presentation/widgets/app_scaffold.dart";
import "../theme/app_colors.dart";
import "../theme/app_spacing.dart";
import "app_navigator_key.dart";
import "app_routes.dart";
import "app_transitions.dart";

part "app_router.g.dart";

/// GoRouter global de FitTracker.
///
/// - `/` → onboarding (une seule fois, pas de persistance pour l'instant).
/// - `StatefulShellRoute.indexedStack` à 3 branches : `/home`, `/exercises`,
///   `/history`.
///
/// `/profile` reste défini dans [AppRoutes] mais n'est plus dans la bottom
/// nav — écran pas encore implémenté (hors scope de ce module).
///
/// Pas d'auth (Drift = stockage local, pas de backend) : aucune route
/// `/auth/**`.
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    navigatorKey: AppNavigatorKey.instance,
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.root,
    errorBuilder: (context, state) => const _RouterErrorPage(),
    routes: [
      // ─── Onboarding ───────────────────────────
      GoRoute(
        path: AppRoutes.root,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const WelcomePage(),
        ),
      ),

      // ─── Exercise ───────────────────────────
      GoRoute(
        path: AppRoutes.exerciseDetail,
        pageBuilder: (context, state) {
          final id = state.pathParameters["id"] ?? "";
          return AppTransitions.fade(
            context: context,
            state: state,
            child: ExerciseDetailPage(id: id),
          );
        },
      ),

      // ─── Programmes (hors shell) ─────────────
      GoRoute(
        path: AppRoutes.programs,
        pageBuilder: (context, state) => AppTransitions.pushedScreen(
          context: context,
          state: state,
          child: const ProgramListPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.programNew,
        pageBuilder: (context, state) => AppTransitions.pushedScreen(
          context: context,
          state: state,
          child: const ProgramEditorPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.programEdit,
        pageBuilder: (context, state) {
          final id = state.pathParameters["id"] ?? "";
          return AppTransitions.pushedScreen(
            context: context,
            state: state,
            child: ProgramEditorPage(programId: id),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.programDetail,
        pageBuilder: (context, state) {
          final id = state.pathParameters["id"] ?? "";
          return AppTransitions.pushedScreen(
            context: context,
            state: state,
            child: ProgramDetailPage(id: id),
          );
        },
      ),

      // ─── Séance active (hors shell) ──────────
      GoRoute(
        path: AppRoutes.activeSession,
        pageBuilder: (context, state) {
          final workoutDayId = state.uri.queryParameters["dayId"];
          return AppTransitions.pushedScreen(
            context: context,
            state: state,
            child: ActiveSessionPage(workoutDayId: workoutDayId),
          );
        },
      ),

      // ─── Shell — 4 onglets ────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.exercises,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const ExerciseLibraryPage(),
                  // child: const _Placeholder(title: "Exercices"),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const SessionHistoryPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Coquille des onglets — Home, Exercices, Historique.
class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    (icon: LucideIcons.house, selectedIcon: LucideIcons.house, label: "Home"),
    (
      icon: LucideIcons.dumbbell,
      selectedIcon: LucideIcons.dumbbell,
      label: "Exercices",
    ),
    (
      icon: LucideIcons.rotateCcwClock,
      selectedIcon: LucideIcons.rotateCcwClock,
      label: "Historique",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: .zero,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          for (final d in _destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: d.label,
            ),
        ],
      ),
    );
  }
}

/// Écran d'erreur du router.
class _RouterErrorPage extends StatelessWidget {
  const _RouterErrorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPaddingH,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Cet écran n'existe pas encore.",
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapVSm,
              Text(
                "Reviens plus tard, ou reprends depuis l'accueil.",
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
