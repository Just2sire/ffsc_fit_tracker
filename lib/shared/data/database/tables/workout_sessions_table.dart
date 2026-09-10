import "package:drift/drift.dart";

import "../../../domain/enums/session_status.dart";
import "exercise_sets_table.dart";
import "session_exercises_table.dart";
import "workout_days_table.dart";
import "workout_programs_table.dart";

/// Une séance réelle, en cours ou terminée.
///
/// Contrairement à [WorkoutDays]/[WorkoutPrograms], cette table subit de
/// vraies suppressions (`DeleteSessionUseCase` de M-10) — d'où le
/// `onDelete: KeyAction.cascade` sur les tables filles ([SessionExercises],
/// puis [ExerciseSets] en cascade indirecte).
class WorkoutSessions extends Table {
  TextColumn get id => text()();

  TextColumn get workoutDayId => text().references(WorkoutDays, #id)();

  /// Copie figée du nom du jour au moment du démarrage — reste correct même
  /// si le jour est renommé ou archivé après coup.
  TextColumn get workoutDayNameSnapshot => text()();

  TextColumn get status => textEnum<SessionStatus>()();

  DateTimeColumn get startedAt => dateTime()();

  /// Renseigné uniquement quand `status = completed`.
  DateTimeColumn get finishedAt => dateTime().nullable()();

  /// Heartbeat mis à jour toutes les 30s pendant que la séance est active,
  /// utilisé pour détecter et récupérer une séance après fermeture de l'app.
  DateTimeColumn get lastActiveAt => dateTime()();

  /// Durée cumulée en pause, en secondes — soustraite du calcul de
  /// `effectiveDuration` (jamais de `Stopwatch`).
  IntColumn get pausedDuration => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
