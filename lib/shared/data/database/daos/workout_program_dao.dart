import "package:drift/drift.dart";

import "../app_database.dart";
import "../tables/workout_programs_table.dart";

part "workout_program_dao.g.dart";

@DriftAccessor(tables: [WorkoutPrograms])
class WorkoutProgramDao extends DatabaseAccessor<AppDatabase>
    with _$WorkoutProgramDaoMixin {
  WorkoutProgramDao(super.db);

  /// Programmes actifs (non archivés).
  Stream<List<WorkoutProgram>> watchAllPrograms() {
    return (select(
      workoutPrograms,
    )..where((table) => table.isArchived.equals(false))).watch();
  }

  Future<List<WorkoutProgram>> getAllPrograms() => (select(
    workoutPrograms,
  )..where((table) => table.isArchived.equals(false))).get();

  Future<WorkoutProgram?> getProgramById(String id) => (select(
    workoutPrograms,
  )..where((table) => table.id.equals(id))).getSingleOrNull();

  Future<void> upsertProgram(WorkoutProgram program) =>
      into(workoutPrograms).insertOnConflictUpdate(program);

  /// Archive un programme — jamais de `DELETE` réel (l'historique des
  /// séances doit continuer à référencer le programme après suppression).
  Future<void> archiveProgram(String id) =>
      (update(workoutPrograms)..where((table) => table.id.equals(id))).write(
        const WorkoutProgramsCompanion(isArchived: Value(true)),
      );
}
