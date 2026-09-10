import "package:drift/drift.dart";

import "../app_database.dart";
import "../tables/exercise_sets_table.dart";

part "exercise_set_dao.g.dart";

@DriftAccessor(tables: [ExerciseSets])
class ExerciseSetDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseSetDaoMixin {
  ExerciseSetDao(super.db);

  Future<List<ExerciseSet>> getSetsForSessionExercise(
    String sessionExerciseId,
  ) => (select(exerciseSets)
        ..where((tbl) => tbl.sessionExerciseId.equals(sessionExerciseId))
        ..orderBy([(tbl) => OrderingTerm.asc(tbl.setNumber)]))
      .get();

  Future<void> insertSet(ExerciseSet set) => into(exerciseSets).insert(set);

  Future<void> updateSet(ExerciseSet set) =>
      (update(exerciseSets)..where(
        (tbl) => tbl.id.equals(set.id),
      )).write(set.toCompanion(true));

  Future<void> deleteSet(String id) =>
      (delete(exerciseSets)..where((tbl) => tbl.id.equals(id))).go();
}
