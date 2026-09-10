// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_day_dao.dart';

// ignore_for_file: type=lint
mixin _$WorkoutDayDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorkoutProgramsTable get workoutPrograms => attachedDatabase.workoutPrograms;
  $WorkoutDaysTable get workoutDays => attachedDatabase.workoutDays;
  WorkoutDayDaoManager get managers => WorkoutDayDaoManager(this);
}

class WorkoutDayDaoManager {
  final _$WorkoutDayDaoMixin _db;
  WorkoutDayDaoManager(this._db);
  $$WorkoutProgramsTableTableManager get workoutPrograms =>
      $$WorkoutProgramsTableTableManager(
        _db.attachedDatabase,
        _db.workoutPrograms,
      );
  $$WorkoutDaysTableTableManager get workoutDays =>
      $$WorkoutDaysTableTableManager(_db.attachedDatabase, _db.workoutDays);
}
