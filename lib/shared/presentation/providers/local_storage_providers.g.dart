// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_storage_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

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

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
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
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'69c47cf089be644ff945eb90b618154c37d0ea5e';

/// Provider du [LocalStorageService].
///
/// Consomme [sharedPreferencesProvider] — aucun état interne,
/// recréé uniquement si les prefs changent.

@ProviderFor(localStorageService)
final localStorageServiceProvider = LocalStorageServiceProvider._();

/// Provider du [LocalStorageService].
///
/// Consomme [sharedPreferencesProvider] — aucun état interne,
/// recréé uniquement si les prefs changent.

final class LocalStorageServiceProvider
    extends
        $FunctionalProvider<
          LocalStorageService,
          LocalStorageService,
          LocalStorageService
        >
    with $Provider<LocalStorageService> {
  /// Provider du [LocalStorageService].
  ///
  /// Consomme [sharedPreferencesProvider] — aucun état interne,
  /// recréé uniquement si les prefs changent.
  LocalStorageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localStorageServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localStorageServiceHash();

  @$internal
  @override
  $ProviderElement<LocalStorageService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalStorageService create(Ref ref) {
    return localStorageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalStorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalStorageService>(value),
    );
  }
}

String _$localStorageServiceHash() =>
    r'44802982a66a1f134a706a216757e197947967c9';
