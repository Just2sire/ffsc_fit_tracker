import "package:drift/drift.dart";

import "../../../domain/enums/session_status.dart";
import "../app_database.dart";
import "../tables/session_exercises_table.dart";
import "../tables/workout_sessions_table.dart";

part "session_exercise_dao.g.dart";

@DriftAccessor(tables: [SessionExercises, WorkoutSessions])
class SessionExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$SessionExerciseDaoMixin {
  SessionExerciseDao(super.db);

  /// Historique d'un exercice à travers les séances terminées, de la plus
  /// récente à la plus ancienne — utilisé par le `ProgressionEngine`.
  Future<List<SessionExercise>> getHistoryForExercise(
    String exerciseId, {
    int limit = 5,
  }) {
    final query = select(sessionExercises).join([
      innerJoin(
        workoutSessions,
        workoutSessions.id.equalsExp(sessionExercises.sessionId),
      ),
    ])
      ..where(
        sessionExercises.exerciseId.equals(exerciseId) &
            workoutSessions.status.equalsValue(SessionStatus.completed),
      )
      ..orderBy([OrderingTerm.desc(workoutSessions.startedAt)])
      ..limit(limit);

    return query.map((row) => row.readTable(sessionExercises)).get();
  }

  Future<List<SessionExercise>> getSessionExercises(String sessionId) =>
      (select(sessionExercises)
            ..where((table) => table.sessionId.equals(sessionId))
            ..orderBy([(table) => OrderingTerm.asc(table.sortOrder)]))
          .get();

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
