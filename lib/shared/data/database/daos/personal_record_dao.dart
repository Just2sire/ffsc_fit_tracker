import "package:drift/drift.dart";

import "../app_database.dart";
import "../tables/personal_records_table.dart";

part "personal_record_dao.g.dart";

@DriftAccessor(tables: [PersonalRecords])
class PersonalRecordDao extends DatabaseAccessor<AppDatabase>
    with _$PersonalRecordDaoMixin {
  PersonalRecordDao(super.db);

  /// Le record personnel courant pour un exercice, s'il existe.
  Future<PersonalRecord?> findByExercise(String exerciseId) =>
      (select(personalRecords)
            ..where((tbl) => tbl.exerciseId.equals(exerciseId)))
          .getSingleOrNull();

  Future<void> insertRecord(PersonalRecord record) =>
      into(personalRecords).insert(record);

  /// Met à jour un record existant — l'appelant doit réutiliser l'`id` du
  /// record trouvé via [findByExercise] (une seule ligne active par
  /// exercice, cf. `uniqueKeys` sur la table).
  Future<void> updateRecord(PersonalRecord record) =>
      (update(personalRecords)..where(
        (tbl) => tbl.id.equals(record.id),
      )).write(record.toCompanion(true));
}
