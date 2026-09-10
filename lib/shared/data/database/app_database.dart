import "package:drift/drift.dart";
import "package:drift_flutter/drift_flutter.dart";

import "../../domain/enums/index.dart";
import "daos/index.dart";
import "tables/index.dart";

part "app_database.g.dart";

@DriftDatabase(
  tables: [
    Exercises,
    WorkoutPrograms,
    WorkoutDays,
    ProgramExercises,
    WorkoutSessions,
    SessionExercises,
    ExerciseSets,
    PersonalRecords,
    BodyWeights,
  ],
  daos: [
    BodyWeightDao,
    ExerciseDao,
    ExerciseSetDao,
    PersonalRecordDao,
    ProgramExerciseDao,
    SessionExerciseDao,
    WorkoutDayDao,
    WorkoutProgramDao,
    WorkoutSessionDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: "fit_tracker_db"));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      beforeOpen: (details) async {
        await customStatement("PRAGMA foreign_keys = ON");
      },
    );
  }
}
