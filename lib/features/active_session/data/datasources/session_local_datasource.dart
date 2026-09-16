import "package:uuid/uuid.dart";

import "../../../../core/utils/progression_engine.dart";
import "../../../../shared/data/database/app_database.dart";
import "../../../../shared/domain/enums/index.dart";
import "../../domain/entities/exercise_set.dart" as entity;
import "../../domain/entities/session_exercise.dart" as entity;
import "../../domain/entities/session_exercise_target.dart" as entity;
import "../../domain/entities/workout_session.dart" as entity;

class SessionLocalDatasource {
  const SessionLocalDatasource(this._database);

  static const _uuid = Uuid();

  final AppDatabase _database;

  Future<entity.WorkoutSession?> findActiveSession() async {
    final row = await _database.workoutSessionDao.findActiveSession();
    return row == null ? null : _sessionToDomain(row);
  }

  Future<entity.WorkoutSession?> getSessionById(String id) async {
    final row = await _database.workoutSessionDao.getSessionById(id);
    return row == null ? null : _sessionToDomain(row);
  }

  Stream<List<entity.WorkoutSession>> watchCompletedSessions() => _database
      .workoutSessionDao
      .watchCompletedSessions()
      .map((rows) => rows.map(_sessionToDomain).toList());

  Future<entity.WorkoutSession> startSession(String workoutDayId) async {
    final day = await _database.workoutDayDao.getDayById(workoutDayId);
    if (day == null) {
      throw ArgumentError("Jour d'entraînement introuvable: $workoutDayId");
    }

    final now = DateTime.now();
    final sessionId = _uuid.v4();

    await _database.workoutSessionDao.upsertSession(
      WorkoutSession(
        id: sessionId,
        workoutDayId: workoutDayId,
        workoutDayNameSnapshot: day.name,
        status: SessionStatus.active,
        startedAt: now,
        lastActiveAt: now,
        pausedDuration: 0,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final programExercises = await _database.programExerciseDao
        .getExercisesForDay(workoutDayId);

    for (final programExercise in programExercises) {
      final exercise = await _database.exerciseDao.getExerciseById(
        programExercise.exerciseId,
      );
      if (exercise == null) continue;

      final sessionExerciseId = _uuid.v4();
      await _database.sessionExerciseDao.upsertSessionExercise(
        SessionExercise(
          id: sessionExerciseId,
          sessionId: sessionId,
          exerciseId: exercise.id,
          exerciseNameSnapshot: exercise.name,
          equipmentSnapshot: exercise.equipment,
          primaryMuscleSnapshot: exercise.muscleGroup,
          sortOrder: programExercise.sortOrder,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final history = await getExerciseHistory(exercise.id);
      final suggestion = ProgressionEngine.suggest(
        pastSessions: history,
        targetRepsMin: programExercise.targetRepsMin,
        targetRepsMax: programExercise.targetRepsMax,
        equipment: exercise.equipment,
        primaryMuscle: exercise.muscleGroup,
      );
      final suggestedWeight = exercise.equipment == Equipment.bodyweight
          ? 0.0
          : (suggestion.suggestedWeight ?? 0.0);
      final targetReps =
          "${programExercise.targetRepsMin}-${programExercise.targetRepsMax}";

      for (
        var setNumber = 1;
        setNumber <= programExercise.targetSets;
        setNumber++
      ) {
        await _database.exerciseSetDao.insertSet(
          ExerciseSet(
            id: _uuid.v4(),
            sessionExerciseId: sessionExerciseId,
            setNumber: setNumber,
            weight: suggestedWeight,
            reps: 0,
            isCompleted: false,
            targetReps: targetReps,
          ),
        );
      }
    }

    return (await getSessionById(sessionId))!;
  }

  Future<void> updateStatus(String id, SessionStatus status) =>
      _database.workoutSessionDao.updateStatus(id, status);

  Future<void> updateHeartbeat(String id) =>
      _database.workoutSessionDao.updateLastActiveAt(id);

  Future<void> completeSession(String id, DateTime finishedAt) =>
      _database.workoutSessionDao.completeSession(id, finishedAt);

  Future<void> resumeFromPause(
    String id, {
    required int pausedDurationSeconds,
  }) => _database.workoutSessionDao.resumeFromPause(
    id,
    pausedDurationSeconds: pausedDurationSeconds,
  );

  Future<List<entity.SessionExercise>> getSessionExercises(
    String sessionId,
  ) async {
    final rows = await _database.sessionExerciseDao.getSessionExercises(
      sessionId,
    );
    return rows.map(_sessionExerciseToDomain).toList();
  }

  Future<List<entity.ExerciseSet>> getSetsForSessionExercise(
    String sessionExerciseId,
  ) async {
    final rows = await _database.exerciseSetDao.getSetsForSessionExercise(
      sessionExerciseId,
    );
    return rows.map(_setToDomain).toList();
  }

  Future<void> logSet(entity.ExerciseSet set) async {
    final companion = ExerciseSet(
      id: set.id,
      sessionExerciseId: set.sessionExerciseId,
      setNumber: set.setNumber,
      weight: set.weight,
      reps: set.reps,
      targetReps: set.targetReps,
      targetWeight: set.targetWeight,
      rpe: set.rpe,
      notes: set.notes,
      isCompleted: set.isCompleted,
      completedAt: set.completedAt,
    );
    final existing = await _database.exerciseSetDao.getSetsForSessionExercise(
      set.sessionExerciseId,
    );
    final alreadyExists = existing.any((row) => row.id == set.id);
    if (alreadyExists) {
      await _database.exerciseSetDao.updateSet(companion);
    } else {
      await _database.exerciseSetDao.insertSet(companion);
    }
  }

  Future<void> deleteSet(String id) => _database.exerciseSetDao.deleteSet(id);

  Future<List<List<entity.ExerciseSet>>> getExerciseHistory(
    String exerciseId, {
    int limit = 5,
  }) async {
    final sessionExercises = await _database.sessionExerciseDao
        .getHistoryForExercise(exerciseId, limit: limit);

    final history = <List<entity.ExerciseSet>>[];
    for (final sessionExercise in sessionExercises) {
      final sets = await _database.exerciseSetDao.getSetsForSessionExercise(
        sessionExercise.id,
      );
      final completedSets = sets.where((s) => s.isCompleted).toList();
      if (completedSets.isNotEmpty) {
        history.add(completedSets.map(_setToDomain).toList());
      }
    }
    return history;
  }

  Future<entity.SessionExerciseTarget?> getTargetForExercise(
    String workoutDayId,
    String exerciseId,
  ) async {
    final programExercises = await _database.programExerciseDao
        .getExercisesForDay(workoutDayId);
    for (final programExercise in programExercises) {
      if (programExercise.exerciseId == exerciseId) {
        return entity.SessionExerciseTarget(
          targetRepsMin: programExercise.targetRepsMin,
          targetRepsMax: programExercise.targetRepsMax,
          restTimeSeconds: programExercise.restTimeSeconds,
        );
      }
    }
    return null;
  }

  entity.WorkoutSession _sessionToDomain(WorkoutSession row) {
    return entity.WorkoutSession(
      id: row.id,
      workoutDayId: row.workoutDayId,
      workoutDayNameSnapshot: row.workoutDayNameSnapshot,
      status: row.status,
      startedAt: row.startedAt,
      finishedAt: row.finishedAt,
      lastActiveAt: row.lastActiveAt,
      pausedDurationSeconds: row.pausedDuration,
    );
  }

  entity.SessionExercise _sessionExerciseToDomain(SessionExercise row) {
    return entity.SessionExercise(
      id: row.id,
      sessionId: row.sessionId,
      exerciseId: row.exerciseId,
      exerciseNameSnapshot: row.exerciseNameSnapshot,
      equipmentSnapshot: row.equipmentSnapshot,
      primaryMuscleSnapshot: row.primaryMuscleSnapshot,
      sortOrder: row.sortOrder,
    );
  }

  entity.ExerciseSet _setToDomain(ExerciseSet row) {
    return entity.ExerciseSet(
      id: row.id,
      sessionExerciseId: row.sessionExerciseId,
      setNumber: row.setNumber,
      weight: row.weight,
      reps: row.reps,
      isCompleted: row.isCompleted,
      targetReps: row.targetReps,
      targetWeight: row.targetWeight,
      rpe: row.rpe,
      notes: row.notes,
      completedAt: row.completedAt,
    );
  }
}
