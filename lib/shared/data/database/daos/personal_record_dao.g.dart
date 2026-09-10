// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_record_dao.dart';

// ignore_for_file: type=lint
mixin _$PersonalRecordDaoMixin on DatabaseAccessor<AppDatabase> {
  $ExercisesTable get exercises => attachedDatabase.exercises;
  $PersonalRecordsTable get personalRecords => attachedDatabase.personalRecords;
  PersonalRecordDaoManager get managers => PersonalRecordDaoManager(this);
}

class PersonalRecordDaoManager {
  final _$PersonalRecordDaoMixin _db;
  PersonalRecordDaoManager(this._db);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db.attachedDatabase, _db.exercises);
  $$PersonalRecordsTableTableManager get personalRecords =>
      $$PersonalRecordsTableTableManager(
        _db.attachedDatabase,
        _db.personalRecords,
      );
}
