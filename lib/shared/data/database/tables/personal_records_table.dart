import "package:drift/drift.dart";

import "exercises_table.dart";

/// Le meilleur 1RM estimé (formule d'Epley) pour un exercice donné.
///
/// Une seule ligne active par exercice — `estimated1RM` est comparé et
/// remplacé à chaque fin de séance (`DetectPersonalRecordsUseCase`, M-09).
class PersonalRecords extends Table {
  TextColumn get id => text()();

  TextColumn get exerciseId => text().references(Exercises, #id)();

  RealColumn get estimated1RM => real()();

  /// Poids et reps réels qui ont produit ce 1RM 
  /// (pour affichage "3×5 @ 100 kg").
  RealColumn get weight => real()();

  IntColumn get reps => integer()();

  DateTimeColumn get achievedAt => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {exerciseId},
  ];
}
