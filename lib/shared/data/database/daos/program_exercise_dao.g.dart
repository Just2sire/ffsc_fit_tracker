// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_exercise_dao.dart';

// ignore_for_file: type=lint
mixin _$ProgramExerciseDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorkoutProgramsTable get workoutPrograms => attachedDatabase.workoutPrograms;
  $WorkoutDaysTable get workoutDays => attachedDatabase.workoutDays;
  $ExercisesTable get exercises => attachedDatabase.exercises;
  $ProgramExercisesTable get programExercises =>
      attachedDatabase.programExercises;
  ProgramExerciseDaoManager get managers => ProgramExerciseDaoManager(this);
}

class ProgramExerciseDaoManager {
  final _$ProgramExerciseDaoMixin _db;
  ProgramExerciseDaoManager(this._db);
  $$WorkoutProgramsTableTableManager get workoutPrograms =>
      $$WorkoutProgramsTableTableManager(
        _db.attachedDatabase,
        _db.workoutPrograms,
      );
  $$WorkoutDaysTableTableManager get workoutDays =>
      $$WorkoutDaysTableTableManager(_db.attachedDatabase, _db.workoutDays);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db.attachedDatabase, _db.exercises);
  $$ProgramExercisesTableTableManager get programExercises =>
      $$ProgramExercisesTableTableManager(
        _db.attachedDatabase,
        _db.programExercises,
      );
}
