import "../entities/program_exercise.dart";
import "../repositories/program_repository.dart";

class ReorderProgramExercisesUseCase {
  const ReorderProgramExercisesUseCase(this.repository);

  final ProgramRepository repository;

  Future<void> call(List<ProgramExercise> reorderedExercises) {
    final futures = <Future<void>>[];
    for (var i = 0; i < reorderedExercises.length; i++) {
      final e = reorderedExercises[i];
      if (e.sortOrder == i) continue;
      futures.add(
        repository.updateProgramExercise(
          ProgramExercise(
            id: e.id,
            workoutDayId: e.workoutDayId,
            exerciseId: e.exerciseId,
            sortOrder: i,
            targetSets: e.targetSets,
            targetRepsMin: e.targetRepsMin,
            targetRepsMax: e.targetRepsMax,
            restTimeSeconds: e.restTimeSeconds,
          ),
        ),
      );
    }
    return Future.wait(futures);
  }
}
