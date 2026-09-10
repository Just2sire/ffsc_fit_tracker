import "package:flutter/foundation.dart";

import "../../../core/configs/logger.dart";
import "../database/app_database.dart";

/// Service général responsable de la gestion et du
/// cycle de vie de la base de données SQLite (Drift).
///
/// Ce service fournit une interface centralisée pour :
/// - L'initialisation et la fermeture de la base de données.
/// - L'accès sécurisé à l'instance [AppDatabase].
/// - La purge globale des données (ex: lors d'une déconnexion
/// ou réinitialisation).
/// - L'exécution de transactions et de requêtes personnalisées.
/// - La vérification de la connectivité/santé de la base.
class DatabaseService {
  /// Factory retournant l'instance singleton.
  factory DatabaseService() => _instance;

  /// Constructeur permettant l'injection d'une [AppDatabase] externe
  /// (tests ou injection via Riverpod).
  DatabaseService.withDatabase(this._database);
  DatabaseService._internal();

  /// Instance singleton de [DatabaseService].
  static final DatabaseService _instance = DatabaseService._internal();

  /// Accesseur raccourci pour l'instance singleton.
  static DatabaseService get instance => _instance;

  /// Définit une instance d'[AppDatabase] spécifique pour
  /// les tests (ex: base en mémoire).
  @visibleForTesting
  static void setDatabaseForTesting(AppDatabase db) {
    _instance._database?.close();
    _instance._database = db;
  }

  AppDatabase? _database;

  /// Retourne l'instance courante de [AppDatabase].
  /// Si la base n'est pas encore initialisée, elle est créée à la volée.
  AppDatabase get database {
    _database ??= AppDatabase();
    return _database!;
  }

  /// Indique si la base de données est actuellement ouverte.
  bool get isInitialized => _database != null;

  /// Initialise la base de données de manière explicite.
  ///
  /// Recommandé d'être appelé au démarrage
  /// de l'application (ex: dans `main()`).
  Future<AppDatabase> initialize() async {
    if (_database != null) {
      AppLogger.d("[DatabaseService] Base de données déjà initialisée.");
      return _database!;
    }

    try {
      AppLogger.d("[DatabaseService] Initialisation de la base de données...");
      final db = database;
      // Exécution d'une vérification basique pour
      //confirmer l'ouverture du fichier
      await db.customSelect("SELECT 1").getSingle();
      AppLogger.i(
        "[DatabaseService] Base de données initialisée avec "
        "succès (schema v${db.schemaVersion}).",
      );
      return db;
    } catch (e, stackTrace) {
      AppLogger.e(
        "[DatabaseService] Erreur lors de l'initialisation : $e\n$stackTrace",
      );
      rethrow;
    }
  }

  /// Exécute une opération atomique dans une transaction.
  Future<T> transaction<T>(Future<T> Function() action) async {
    return await database.transaction(action);
  }

  /// Supprime l'intégralité des données de toutes les tables de la base.
  ///
  /// Très utile lors d'une réinitialisation de l'application ou
  /// d'une déconnexion d'utilisateur.
  Future<void> clearAllData() async {
    final db = database;
    AppLogger.i("[DatabaseService] Nettoyage de toutes les tables...");
    await db.transaction(() async {
      // Désactive temporairement les contraintes de clés étrangères
      //pour éviter les conflits d'ordre de suppression
      await db.customStatement("PRAGMA foreign_keys = OFF;");
      try {
        for (final table in db.allTables) {
          await db.delete(table).go();
        }
      } finally {
        await db.customStatement("PRAGMA foreign_keys = ON;");
      }
    });
    AppLogger.i("[DatabaseService] Toutes les données ont été supprimées.");
  }

  /// Vérifie la santé et la réactivité de la base de données.
  Future<bool> checkHealth() async {
    try {
      final result = await database
          .customSelect("SELECT 1 as is_alive")
          .getSingle();
      return result.read<int>("is_alive") == 1;
    } catch (e) {
      AppLogger.e("[DatabaseService] Échec du healthcheck : $e");
      return false;
    }
  }

  /// Récupère des informations générales sur la base de données.
  Future<Map<String, dynamic>> getDatabaseInfo() async {
    final db = database;
    final tableNames = db.allTables.map((t) => t.actualTableName).toList();

    return {
      "schemaVersion": db.schemaVersion,
      "isInitialized": isInitialized,
      "tablesCount": tableNames.length,
      "tables": tableNames,
    };
  }

  /// Ferme proprement la connexion à la base de données
  /// et libère les ressources.
  Future<void> close() async {
    if (_database != null) {
      AppLogger.i("[DatabaseService] Fermeture de la base de données...");
      await _database!.close();
      _database = null;
      AppLogger.i("[DatabaseService] Base de données fermée.");
    }
  }
}
