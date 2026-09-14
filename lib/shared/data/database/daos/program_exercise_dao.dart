import "package:drift/drift.dart";

import "../app_database.dart";
import "../tables/program_exercises_table.dart";

part "program_exercise_dao.g.dart";

@DriftAccessor(tables: [ProgramExercises])
class ProgramExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$ProgramExerciseDaoMixin {
  ProgramExerciseDao(super.db);

  /// Exercices d'un jour de programme, dans l'ordre d'affichage.
  Future<List<ProgramExercise>> getExercisesForDay(String workoutDayId) =>
      (select(programExercises)
            ..where((table) => table.workoutDayId.equals(workoutDayId))
            ..orderBy([(table) => OrderingTerm.asc(table.sortOrder)]))
          .get();

  Future<void> insertProgramExercise(ProgramExercisesCompanion companion) =>
      into(programExercises).insert(companion);

  Future<void> upsertProgramExercise(ProgramExercisesCompanion companion) =>
      into(programExercises).insertOnConflictUpdate(companion);

  Future<void> deleteProgramExercise(String workoutDayId, String exerciseId) =>
      (delete(programExercises)
            ..where((table) => table.workoutDayId.equals(workoutDayId))
            ..where((table) => table.exerciseId.equals(exerciseId)))
          .go();
}
