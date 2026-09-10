import "package:drift/drift.dart";

import "../../../domain/enums/training_goal.dart";

/// Un programme d'entraînement créé par l'utilisateur (ex: "PPL", "Full Body").
///
/// Soft delete uniquement : ne jamais `DELETE`, toujours passer par
/// `isArchived` — l'historique des séances doit continuer à référencer le
/// programme même après suppression.
class WorkoutPrograms extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get goal => textEnum<TrainingGoal>()();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
