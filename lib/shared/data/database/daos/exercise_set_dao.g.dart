// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_set_dao.dart';

// ignore_for_file: type=lint
mixin _$ExerciseSetDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorkoutProgramsTable get workoutPrograms => attachedDatabase.workoutPrograms;
  $WorkoutDaysTable get workoutDays => attachedDatabase.workoutDays;
  $WorkoutSessionsTable get workoutSessions => attachedDatabase.workoutSessions;
  $ExercisesTable get exercises => attachedDatabase.exercises;
  $SessionExercisesTable get sessionExercises =>
      attachedDatabase.sessionExercises;
  $ExerciseSetsTable get exerciseSets => attachedDatabase.exerciseSets;
  ExerciseSetDaoManager get managers => ExerciseSetDaoManager(this);
}

class ExerciseSetDaoManager {
  final _$ExerciseSetDaoMixin _db;
  ExerciseSetDaoManager(this._db);
  $$WorkoutProgramsTableTableManager get workoutPrograms =>
      $$WorkoutProgramsTableTableManager(
        _db.attachedDatabase,
        _db.workoutPrograms,
      );
  $$WorkoutDaysTableTableManager get workoutDays =>
      $$WorkoutDaysTableTableManager(_db.attachedDatabase, _db.workoutDays);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(
        _db.attachedDatabase,
        _db.workoutSessions,
      );
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db.attachedDatabase, _db.exercises);
  $$SessionExercisesTableTableManager get sessionExercises =>
      $$SessionExercisesTableTableManager(
        _db.attachedDatabase,
        _db.sessionExercises,
      );
  $$ExerciseSetsTableTableManager get exerciseSets =>
      $$ExerciseSetsTableTableManager(_db.attachedDatabase, _db.exerciseSets);
}
