import "package:shared_preferences/shared_preferences.dart";

// ─── Clés ────────────────────────────────────────────────────────────────────

/// Toutes les clés SharedPreferences centralisées.
///
/// Ajouter une nouvelle clé ici, jamais en dur dans les call-sites.
abstract final class StorageKeys {
  // ─── Onboarding ─────────────────────────────
  static const String onboardingCompleted = "onboarding_completed";

  // ─── Thème ──────────────────────────────────
  static const String themeMode = "theme_mode"; // 'system' | 'light' | 'dark'

  // ─── Unités ─────────────────────────────────
  static const String weightUnit = "weight_unit"; // 'kg' | 'lbs'
  static const String distanceUnit = "distance_unit"; // 'km' | 'mi'
}

// ─── Service ─────────────────────────────────────────────────────────────────

/// Couche d'abstraction autour de [SharedPreferences].
///
/// Expose des méthodes nommées et typées pour chaque donnée persistée,
/// plutôt que de manipuler les clés brutes à travers toute l'app.
class LocalStorageService {
  const LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  // ─── API générique (usage interne ou avancé) ─

  /// Lit une valeur de type [T] depuis le stockage.
  /// Retourne `null` si la clé est absente.
  T? read<T>(String key) => _prefs.get(key) as T?;

  /// Écrit une valeur. Supporte [bool], [int], [double], 
  /// [String], [List<String>].
  Future<void> write<T>(String key, T value) async {
    switch (value) {
      case final bool v:
        await _prefs.setBool(key, v);
      case final int v:
        await _prefs.setInt(key, v);
      case final double v:
        await _prefs.setDouble(key, v);
      case final String v:
        await _prefs.setString(key, v);
      case final List<String> v:
        await _prefs.setStringList(key, v);
      default:
        throw ArgumentError(
          "Type non supporté : ${value.runtimeType}. "
          "Utilise bool, int, double, String ou List<String>.",
        );
    }
  }

  /// Supprime une clé du stockage.
  Future<void> remove(String key) => _prefs.remove(key);

  /// Vide tout le stockage (⚠ irréversible).
  Future<void> clear() => _prefs.clear();

  // ─── Onboarding ─────────────────────────────

  bool get isOnboardingCompleted =>
      _prefs.getBool(StorageKeys.onboardingCompleted) ?? false;

  Future<void> setOnboardingCompleted({bool value = true}) =>
      write(StorageKeys.onboardingCompleted, value);

  // ─── Thème ──────────────────────────────────

  /// Retourne le mode de thème stocké (`'system'`, `'light'`, `'dark'`).
  /// Défaut : `'system'`.
  String get themeMode => _prefs.getString(StorageKeys.themeMode) ?? "system";

  Future<void> setThemeMode(String mode) => write(StorageKeys.themeMode, mode);

  // ─── Unités ─────────────────────────────────

  /// Retourne l'unité de poids (`'kg'` ou `'lbs'`). Défaut : `'kg'`.
  String get weightUnit => _prefs.getString(StorageKeys.weightUnit) ?? "kg";

  Future<void> setWeightUnit(String unit) =>
      write(StorageKeys.weightUnit, unit);

  /// Retourne l'unité de distance (`'km'` ou `'mi'`). Défaut : `'km'`.
  String get distanceUnit => _prefs.getString(StorageKeys.distanceUnit) ?? "km";

  Future<void> setDistanceUnit(String unit) =>
      write(StorageKeys.distanceUnit, unit);
}
