import "package:drift/drift.dart";

import "../../../domain/enums/session_status.dart";
import "../app_database.dart";
import "../tables/workout_sessions_table.dart";

part "workout_session_dao.g.dart";

@DriftAccessor(tables: [WorkoutSessions])
class WorkoutSessionDao extends DatabaseAccessor<AppDatabase>
    with _$WorkoutSessionDaoMixin {
  WorkoutSessionDao(super.db);

  Stream<List<WorkoutSession>> watchSessionsForDay(String workoutDayId) =>
      (select(workoutSessions)
            ..where((table) => table.workoutDayId.equals(workoutDayId))
            ..orderBy([(table) => OrderingTerm.desc(table.startedAt)]))
          .watch();

  Future<WorkoutSession?> getSessionById(String sessionId) => (select(
    workoutSessions,
  )..where((table) => table.id.equals(sessionId))).getSingleOrNull();

  /// Séance active ou en pause, pour la reprise après fermeture de l'app.
  Future<WorkoutSession?> findActiveSession() =>
      (select(workoutSessions)..where(
            (table) => table.status.isInValues([
              SessionStatus.active,
              SessionStatus.paused,
            ]),
          ))
          .getSingleOrNull();

  Future<void> updateStatus(String id, SessionStatus status) =>
      (update(workoutSessions)..where((table) => table.id.equals(id))).write(
        WorkoutSessionsCompanion(
          status: Value(status),
          updatedAt: Value(DateTime.now()),
        ),
      );

  /// Heartbeat (toutes les 30s) pendant qu'une séance est active.
  Future<void> updateLastActiveAt(String id) =>
      (update(workoutSessions)..where((table) => table.id.equals(id))).write(
        WorkoutSessionsCompanion(lastActiveAt: Value(DateTime.now())),
      );

  Future<List<WorkoutSession>> getRecentSessions(int limit) =>
      (select(workoutSessions)
            ..orderBy([(table) => OrderingTerm.desc(table.startedAt)])
            ..limit(limit))
          .get();

  Future<void> upsertSession(WorkoutSession session) =>
      into(workoutSessions).insertOnConflictUpdate(session);

  /// Seule table du schéma à subir un vrai `DELETE` (pas de soft delete) —
  /// cascade automatiquement vers `session_exercises` puis `exercise_sets`.
  Future<void> deleteSession(String id) =>
      (delete(workoutSessions)..where((table) => table.id.equals(id))).go();
}
