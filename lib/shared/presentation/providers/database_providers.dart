import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../data/database/app_database.dart";
import "../../data/services/database_service.dart";

part "database_providers.g.dart";

// ─── AppDatabase ─────────────────────────────────────────────────────────────

/// Provider de l'instance [AppDatabase] (Drift).
///
/// La connexion est fermée proprement lorsque le provider est détruit
/// (ex: sortie de `ProviderScope`).
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

// ─── DatabaseService ─────────────────────────────────────────────────────────

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
@Riverpod(keepAlive: true)
DatabaseService databaseService(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DatabaseService.withDatabase(db);
}
