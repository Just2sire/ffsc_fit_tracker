// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_program_dao.dart';

// ignore_for_file: type=lint
mixin _$WorkoutProgramDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorkoutProgramsTable get workoutPrograms => attachedDatabase.workoutPrograms;
  WorkoutProgramDaoManager get managers => WorkoutProgramDaoManager(this);
}

class WorkoutProgramDaoManager {
  final _$WorkoutProgramDaoMixin _db;
  WorkoutProgramDaoManager(this._db);
  $$WorkoutProgramsTableTableManager get workoutPrograms =>
      $$WorkoutProgramsTableTableManager(
        _db.attachedDatabase,
        _db.workoutPrograms,
      );
}
