import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../../data/services/local_storage_service.dart";

part "local_storage_providers.g.dart";

// ─── SharedPreferences ───────────────────────────────────────────────────────

/// Provider de l'instance [SharedPreferences].
///
/// Doit être overridé dans `main.dart` **avant** `runApp` :
///
/// ```dart
/// final prefs = await SharedPreferences.getInstance();
/// runApp(
///   ProviderScope(
///     overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
///     child: const App(),
///   ),
/// );
/// ```
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError("Override in main via ProviderScope");
}

// ─── LocalStorageService ─────────────────────────────────────────────────────

/// Provider du [LocalStorageService].
///
/// Consomme [sharedPreferencesProvider] — aucun état interne,
/// recréé uniquement si les prefs changent.
@Riverpod(keepAlive: true)
LocalStorageService localStorageService(Ref ref) {
  return LocalStorageService(ref.watch(sharedPreferencesProvider));
}
