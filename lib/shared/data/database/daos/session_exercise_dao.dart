import "package:drift/drift.dart";

import "../app_database.dart";
import "../tables/session_exercises_table.dart";

part "session_exercise_dao.g.dart";

@DriftAccessor(tables: [SessionExercises])
class SessionExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$SessionExerciseDaoMixin {
  SessionExerciseDao(super.db);

  Stream<List<SessionExercise>> watchSessionExercises(String sessionId) =>
      (select(sessionExercises)
            ..where((table) => table.sessionId.equals(sessionId))
            ..orderBy([(table) => OrderingTerm.asc(table.sortOrder)]))
          .watch();

  Future<SessionExercise?> getSessionExercise(String id) => (select(
    sessionExercises,
  )..where((table) => table.id.equals(id))).getSingleOrNull();

  Future<void> upsertSessionExercise(SessionExercise sessionExercise) =>
      into(sessionExercises).insertOnConflictUpdate(sessionExercise);

  Future<void> deleteSessionExercise(String id) =>
      (delete(sessionExercises)..where((table) => table.id.equals(id))).go();

  Future<int> deleteSessionExercises(String sessionId) =>
      (delete(sessionExercises)
            ..where((table) => table.sessionId.equals(sessionId)))
          .go();
}
