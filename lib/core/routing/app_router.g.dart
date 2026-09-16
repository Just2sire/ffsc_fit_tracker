// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// GoRouter global de FitTracker.
///
/// Structure minimale, en attendant les vraies features :
/// - `/` → onboarding (une seule fois, pas de persistance pour l'instant).
/// - `StatefulShellRoute.indexedStack` à 4 branches : `/home`, `/exercises`,
///   `/history`, `/profile` — chaque écran est un placeholder texte centré.
///
/// Pas d'auth (Drift = stockage local, pas de backend) : aucune route
/// `/auth/**`.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// GoRouter global de FitTracker.
///
/// Structure minimale, en attendant les vraies features :
/// - `/` → onboarding (une seule fois, pas de persistance pour l'instant).
/// - `StatefulShellRoute.indexedStack` à 4 branches : `/home`, `/exercises`,
///   `/history`, `/profile` — chaque écran est un placeholder texte centré.
///
/// Pas d'auth (Drift = stockage local, pas de backend) : aucune route
/// `/auth/**`.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// GoRouter global de FitTracker.
  ///
  /// Structure minimale, en attendant les vraies features :
  /// - `/` → onboarding (une seule fois, pas de persistance pour l'instant).
  /// - `StatefulShellRoute.indexedStack` à 4 branches : `/home`, `/exercises`,
  ///   `/history`, `/profile` — chaque écran est un placeholder texte centré.
  ///
  /// Pas d'auth (Drift = stockage local, pas de backend) : aucune route
  /// `/auth/**`.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'd22e32fda56ed49b0072a790051f9b5128211d0a';
