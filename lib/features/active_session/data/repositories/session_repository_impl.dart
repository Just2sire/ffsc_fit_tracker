import "package:fit_tracker/features/active_session/data/datasources/session_local_datasource.dart";
import "package:fit_tracker/features/active_session/domain/entities/exercise_set.dart";
import "package:fit_tracker/features/active_session/domain/entities/session_exercise.dart";
import "package:fit_tracker/features/active_session/domain/entities/session_exercise_target.dart";
import "package:fit_tracker/features/active_session/domain/entities/workout_session.dart";
import "package:fit_tracker/features/active_session/domain/exceptions/invalid_session_transition_exception.dart";
import "package:fit_tracker/features/active_session/domain/repositories/session_repository.dart";
import "package:fit_tracker/shared/domain/enums/index.dart";

class SessionRepositoryImpl implements SessionRepository {
  const SessionRepositoryImpl(this.datasource);

  final SessionLocalDatasource datasource;

  @override
  Future<WorkoutSession?> findActiveSession() =>
      datasource.findActiveSession();

  @override
  Future<WorkoutSession?> getSessionById(String id) =>
      datasource.getSessionById(id);

  @override
  Future<WorkoutSession> startSession(String workoutDayId) async {
    final existing = await datasource.findActiveSession();
    if (existing != null) {
      throw InvalidSessionTransitionException(
        from: existing.status,
        attempted: "start",
      );
    }
    return datasource.startSession(workoutDayId);
  }

  @override
  Future<WorkoutSession> pauseSession(String id) async {
    final session = await _requireSession(id);
    if (session.status != SessionStatus.active) {
      throw InvalidSessionTransitionException(
        from: session.status,
        attempted: "pause",
      );
    }
    await datasource.updateStatus(id, SessionStatus.paused);
    await datasource.updateHeartbeat(id);
    return (await datasource.getSessionById(id))!;
  }

  @override
  Future<WorkoutSession> resumeSession(String id) async {
    final session = await _requireSession(id);
    if (session.status != SessionStatus.paused) {
      throw InvalidSessionTransitionException(
        from: session.status,
        attempted: "resume",
      );
    }
    final pausedElapsed = DateTime.now().difference(session.lastActiveAt);
    await datasource.resumeFromPause(
      id,
      pausedDurationSeconds:
          session.pausedDurationSeconds + pausedElapsed.inSeconds,
    );
    return (await datasource.getSessionById(id))!;
  }

  @override
  Future<WorkoutSession> completeSession(String id) async {
    final session = await _requireSession(id);
    if (session.status != SessionStatus.active) {
      throw InvalidSessionTransitionException(
        from: session.status,
        attempted: "complete",
      );
    }
    await datasource.completeSession(id, DateTime.now());
    return (await datasource.getSessionById(id))!;
  }

  @override
  Future<WorkoutSession> abandonSession(String id) async {
    final session = await _requireSession(id);
    if (session.status != SessionStatus.active &&
        session.status != SessionStatus.paused) {
      throw InvalidSessionTransitionException(
        from: session.status,
        attempted: "abandon",
      );
    }
    await datasource.updateStatus(id, SessionStatus.abandoned);
    return (await datasource.getSessionById(id))!;
  }

  @override
  Future<void> updateHeartbeat(String id) => datasource.updateHeartbeat(id);

  @override
  Future<List<SessionExercise>> getSessionExercises(String sessionId) =>
      datasource.getSessionExercises(sessionId);

  @override
  Future<List<ExerciseSet>> getSetsForSessionExercise(
    String sessionExerciseId,
  ) => datasource.getSetsForSessionExercise(sessionExerciseId);

  @override
  Future<void> logSet(ExerciseSet set) => datasource.logSet(set);

  @override
  Future<void> deleteSet(String id) => datasource.deleteSet(id);

  @override
  Future<List<List<ExerciseSet>>> getExerciseHistory(
    String exerciseId, {
    int limit = 5,
  }) => datasource.getExerciseHistory(exerciseId, limit: limit);

  @override
  Future<SessionExerciseTarget?> getTargetForExercise(
    String workoutDayId,
    String exerciseId,
  ) => datasource.getTargetForExercise(workoutDayId, exerciseId);

  Future<WorkoutSession> _requireSession(String id) async {
    final session = await datasource.getSessionById(id);
    if (session == null) {
      throw ArgumentError("Séance introuvable: $id");
    }
    return session;
  }
}
