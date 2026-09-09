import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../theme/app_colors.dart";
import "../theme/app_spacing.dart";
import "app_navigator_key.dart";
import "app_routes.dart";
import "app_transitions.dart";

part "app_router.g.dart";

/// GoRouter global de FitTracker.
///
/// Structure minimale, en attendant les vraies features :
/// - `/` → onboarding (une seule fois, pas de persistance pour l'instant).
/// - `StatefulShellRoute.indexedStack` à 4 branches : `/home`, `/exercises`,
///   `/history`, `/profile` — chaque écran est un placeholder texte centré.
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
          child: const _OnboardingPage(),
        ),
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
                  child: const _Placeholder(title: "Accueil"),
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
                  child: const _Placeholder(title: "Exercices"),
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
                  child: const _Placeholder(title: "Historique"),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const _Placeholder(title: "Profil"),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Onboarding — placeholder, un seul écran avec un bouton pour continuer.
class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPaddingH,
          child: Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Text(
                  "Bienvenue sur FitTracker",
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapVSm,
                Text(
                  "Onboarding — bientôt.",
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapVXxl,
                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: const Text("Continuer"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Coquille des 4 onglets — placeholder texte centré par onglet.
class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    (icon: Icons.home_outlined, selectedIcon: Icons.home, label: "Accueil"),
    (
      icon: Icons.fitness_center_outlined,
      selectedIcon: Icons.fitness_center,
      label: "Exercices",
    ),
    (
      icon: Icons.history_outlined,
      selectedIcon: Icons.history,
      label: "Historique",
    ),
    (icon: Icons.person_outline, selectedIcon: Icons.person, label: "Profil"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

/// Écran placeholder — texte centré, en attendant l'implémentation réelle.
class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), elevation: 0),
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPaddingH,
          child: Text(
            "$title — bientôt.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ),
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
          icon: const Icon(Icons.arrow_back_ios_new),
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
