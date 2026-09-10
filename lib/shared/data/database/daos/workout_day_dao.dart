import "package:drift/drift.dart";

import "../app_database.dart";
import "../tables/workout_days_table.dart";

part "workout_day_dao.g.dart";

@DriftAccessor(tables: [WorkoutDays])
class WorkoutDayDao extends DatabaseAccessor<AppDatabase>
    with _$WorkoutDayDaoMixin {
  WorkoutDayDao(super.db);

  /// Jours actifs d'un programme donné (non archivés), triés par jour.
  Stream<List<WorkoutDay>> watchProgramDays(String programId) {
    return (select(workoutDays)
          ..where((table) => table.programId.equals(programId))
          ..where((table) => table.isArchived.equals(false))
          ..orderBy([(table) => OrderingTerm.asc(table.dayOrder)]))
        .watch();
  }

  Future<void> upsertDay(WorkoutDay day) =>
      into(workoutDays).insertOnConflictUpdate(day);

  /// Archive un jour — jamais de `DELETE` réel sur cette table (l'historique
  /// des séances doit rester lisible même après suppression du jour).
  Future<void> softDelete(String id) =>
      (update(workoutDays)..where((tbl) => tbl.id.equals(id))).write(
        const WorkoutDaysCompanion(isArchived: Value(true)),
      );
}
