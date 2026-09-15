import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/presentation/providers/database_providers.dart";
import "../../data/datasources/program_local_datasource.dart";
import "../../data/repositories/program_repository_impl.dart";
import "../../domain/entities/index.dart";
import "../../domain/repositories/program_repository.dart";
import "../../domain/usecases/add_exercise_to_day_usecase.dart";
import "../../domain/usecases/archive_program_usecase.dart";
import "../../domain/usecases/delete_day_usecase.dart";
import "../../domain/usecases/remove_exercise_from_day_usecase.dart";
import "../../domain/usecases/reorder_program_exercises_usecase.dart";
import "../../domain/usecases/save_day_usecase.dart";
import "../../domain/usecases/save_program_usecase.dart";

part "program_provider.g.dart";

@Riverpod(keepAlive: true)
ProgramRepository programRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final datasource = ProgramLocalDatasource(db);
  return ProgramRepositoryImpl(datasource);
}

/// Liste de tous les programmes actifs — se met à jour automatiquement
/// dès qu'un programme est créé, modifié ou archivé.
@riverpod
Stream<List<WorkoutProgram>> programsStream(Ref ref) =>
    ref.watch(programRepositoryProvider).watchAllPrograms();

/// Jours d'un programme donné, ordonnés par [WorkoutDay.dayOrder].
/// Se met à jour automatiquement dès qu'un jour est ajouté / réordonné.
@riverpod
Stream<List<WorkoutDay>> programDaysStream(Ref ref, String programId) =>
    ref.watch(programRepositoryProvider).watchProgramDays(programId);

/// Nombre total de jours actifs — toutes programmes confondus.
@riverpod
Stream<int> totalDaysCount(Ref ref) =>
    ref.watch(programRepositoryProvider).watchTotalDaysCount();

/// Programme par ID — utilisé pour les écrans de détail / édition.
@riverpod
Future<WorkoutProgram?> programById(Ref ref, String id) =>
    ref.watch(programRepositoryProvider).getProgramById(id);

/// Exercices prescrits pour un jour, ordonnés par [ProgramExercise.sortOrder].
@riverpod
Future<List<ProgramExercise>> exercisesForDay(
  Ref ref,
  String workoutDayId,
) => ref.watch(programRepositoryProvider).getExercisesForDay(workoutDayId);

/// Notifier centralisant toutes les opérations d'écriture du module.
///
/// Expose un [AsyncValue<void>] pour que l'UI puisse afficher un indicateur
/// de chargement et intercepter les erreurs sans logique try/catch dispersée.
///
/// Les streams ([programsStreamProvider], [programDaysStreamProvider])
/// se rafraîchissent automatiquement après chaque mutation — pas besoin
/// d'invalidation manuelle.
@riverpod
class ProgramMutations extends _$ProgramMutations {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> saveProgram(WorkoutProgram program) => _run(
    SaveProgramUseCase(ref.read(programRepositoryProvider)).call(program),
  );

  Future<void> archiveProgram(String id) => _run(
    ArchiveProgramUseCase(ref.read(programRepositoryProvider)).call(id),
  );

  Future<void> saveDay(WorkoutDay day) => _run(
    SaveDayUseCase(ref.read(programRepositoryProvider)).call(day),
  );

  Future<void> deleteDay(String id) => _run(
    DeleteDayUseCase(ref.read(programRepositoryProvider)).call(id),
  );

  Future<void> addExerciseToDay(ProgramExercise exercise) => _run(
    AddExerciseToDayUseCase(
      ref.read(programRepositoryProvider),
    ).call(exercise),
  );

  Future<void> removeExerciseFromDay(
    String workoutDayId,
    String exerciseId,
  ) => _run(
    RemoveExerciseFromDayUseCase(
      ref.read(programRepositoryProvider),
    ).call(workoutDayId, exerciseId),
  );

  Future<void> reorderExercises(List<ProgramExercise> reordered) => _run(
    ReorderProgramExercisesUseCase(
      ref.read(programRepositoryProvider),
    ).call(reordered),
  );

  Future<void> _run(Future<void> action) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => action);
  }
}
