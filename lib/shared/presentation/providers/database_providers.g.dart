// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider de l'instance [AppDatabase] (Drift).
///
/// La connexion est fermée proprement lorsque le provider est détruit
/// (ex: sortie de `ProviderScope`).

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// Provider de l'instance [AppDatabase] (Drift).
///
/// La connexion est fermée proprement lorsque le provider est détruit
/// (ex: sortie de `ProviderScope`).

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// Provider de l'instance [AppDatabase] (Drift).
  ///
  /// La connexion est fermée proprement lorsque le provider est détruit
  /// (ex: sortie de `ProviderScope`).
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'59cce38d45eeaba199eddd097d8e149d66f9f3e1';

/// Provider du [DatabaseService].
///
/// Consomme [appDatabaseProvider] — le service ne possède pas la DB,
/// il délègue simplement au provider.
///
/// Usage :
/// ```dart
/// final dbService = ref.read(databaseServiceProvider);
/// await dbService.clearAllData();
/// ```

@ProviderFor(databaseService)
final databaseServiceProvider = DatabaseServiceProvider._();

/// Provider du [DatabaseService].
///
/// Consomme [appDatabaseProvider] — le service ne possède pas la DB,
/// il délègue simplement au provider.
///
/// Usage :
/// ```dart
/// final dbService = ref.read(databaseServiceProvider);
/// await dbService.clearAllData();
/// ```

final class DatabaseServiceProvider
    extends
        $FunctionalProvider<DatabaseService, DatabaseService, DatabaseService>
    with $Provider<DatabaseService> {
  /// Provider du [DatabaseService].
  ///
  /// Consomme [appDatabaseProvider] — le service ne possède pas la DB,
  /// il délègue simplement au provider.
  ///
  /// Usage :
  /// ```dart
  /// final dbService = ref.read(databaseServiceProvider);
  /// await dbService.clearAllData();
  /// ```
  DatabaseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseServiceHash();

  @$internal
  @override
  $ProviderElement<DatabaseService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DatabaseService create(Ref ref) {
    return databaseService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DatabaseService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DatabaseService>(value),
    );
  }
}

String _$databaseServiceHash() => r'ff36e2527d630acdf402e93548d2c9658dc3693e';
