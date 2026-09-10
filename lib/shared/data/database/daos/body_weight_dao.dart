import "package:drift/drift.dart";

import "../app_database.dart";
import "../tables/body_weights_table.dart";

part "body_weight_dao.g.dart";

@DriftAccessor(tables: [BodyWeights])
class BodyWeightDao extends DatabaseAccessor<AppDatabase>
    with _$BodyWeightDaoMixin {
  BodyWeightDao(super.db);

  Stream<List<BodyWeight>> watchAll() =>
      (select(bodyWeights)
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.recordedAt)]))
          .watch();

  Future<void> insertWeight(BodyWeight entry) =>
      into(bodyWeights).insert(entry);

  Future<void> updateWeight(BodyWeight entry) =>
      (update(bodyWeights)..where((tbl) => tbl.id.equals(entry.id)))
          .write(entry.toCompanion(true));

  Future<void> deleteWeight(String id) =>
      (delete(bodyWeights)..where((tbl) => tbl.id.equals(id))).go();
}
