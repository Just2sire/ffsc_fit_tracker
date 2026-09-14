import "package:drift/drift.dart" show Value;

import "../../../../shared/data/database/app_database.dart";
import "../../domain/entities/index.dart" as domain;

class ProgramLocalDatasource {
  const ProgramLocalDatasource(this._database);

  final AppDatabase _database;

  // ─── WorkoutProgram ─────────────────────────────────

  Stream<List<domain.WorkoutProgram>> watchAllPrograms() =>
      _database.workoutProgramDao
          .watchAllPrograms()
          .map((rows) => rows.map(_programToDomain).toList());

  Future<List<domain.WorkoutProgram>> getAllPrograms() async {
    final rows = await _database.workoutProgramDao.getAllPrograms();
    return rows.map(_programToDomain).toList();
  }

  Future<domain.WorkoutProgram?> getProgramById(String id) async {
    final row = await _database.workoutProgramDao.getProgramById(id);
    return row == null ? null : _programToDomain(row);
  }

  Future<void> saveProgram(domain.WorkoutProgram program) =>
      _database.workoutProgramDao.upsertProgram(
        WorkoutProgramsCompanion(
          id: Value(program.id),
          name: Value(program.name),
          goal: Value(program.goal),
          isArchived: Value(program.isArchived),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> archiveProgram(String id) =>
      _database.workoutProgramDao.archiveProgram(id);

  // ─── WorkoutDay ─────────────────────────────────────

  Stream<List<domain.WorkoutDay>> watchProgramDays(String programId) =>
      _database.workoutDayDao
          .watchProgramDays(programId)
          .map((rows) => rows.map(_dayToDomain).toList());

  Future<void> saveDay(domain.WorkoutDay day) =>
      _database.workoutDayDao.upsertDay(
        WorkoutDaysCompanion(
          id: Value(day.id),
          programId: Value(day.programId),
          name: Value(day.name),
          dayOrder: Value(day.dayOrder),
          isArchived: Value(day.isArchived),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> deleteDay(String id) => _database.workoutDayDao.softDelete(id);

  // ─── ProgramExercise ─────────────────────────────────

  Future<List<domain.ProgramExercise>> getExercisesForDay(
    String workoutDayId,
  ) async {
    final rows =
        await _database.programExerciseDao.getExercisesForDay(workoutDayId);
    return rows.map(_exerciseToDomain).toList();
  }

  Future<void> addExerciseToDay(domain.ProgramExercise exercise) =>
      _database.programExerciseDao.insertProgramExercise(
        _toExerciseCompanion(exercise),
      );

  Future<void> updateProgramExercise(domain.ProgramExercise exercise) =>
      _database.programExerciseDao.upsertProgramExercise(
        _toExerciseCompanion(exercise),
      );

  Future<void> removeExerciseFromDay(
    String workoutDayId,
    String exerciseId,
  ) => _database.programExerciseDao.deleteProgramExercise(
    workoutDayId,
    exerciseId,
  );

  // ─── Mappers ─────────────────────────────────────────

  domain.WorkoutProgram _programToDomain(WorkoutProgram row) =>
      domain.WorkoutProgram(
        id: row.id,
        name: row.name,
        goal: row.goal,
        isArchived: row.isArchived,
      );

  domain.WorkoutDay _dayToDomain(WorkoutDay row) => domain.WorkoutDay(
    id: row.id,
    programId: row.programId,
    name: row.name,
    dayOrder: row.dayOrder,
    isArchived: row.isArchived,
  );

  domain.ProgramExercise _exerciseToDomain(ProgramExercise row) =>
      domain.ProgramExercise(
        id: row.id,
        workoutDayId: row.workoutDayId,
        exerciseId: row.exerciseId,
        sortOrder: row.sortOrder,
        targetSets: row.targetSets,
        targetRepsMin: row.targetRepsMin,
        targetRepsMax: row.targetRepsMax,
        restTimeSeconds: row.restTimeSeconds,
      );

  ProgramExercisesCompanion _toExerciseCompanion(
    domain.ProgramExercise exercise,
  ) => ProgramExercisesCompanion(
    id: Value(exercise.id),
    workoutDayId: Value(exercise.workoutDayId),
    exerciseId: Value(exercise.exerciseId),
    sortOrder: Value(exercise.sortOrder),
    targetSets: Value(exercise.targetSets),
    targetRepsMin: Value(exercise.targetRepsMin),
    targetRepsMax: Value(exercise.targetRepsMax),
    restTimeSeconds: Value(exercise.restTimeSeconds),
    updatedAt: Value(DateTime.now()),
  );
}
