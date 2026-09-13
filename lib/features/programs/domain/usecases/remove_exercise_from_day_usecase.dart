import "../repositories/program_repository.dart";

class RemoveExerciseFromDayUseCase {
  const RemoveExerciseFromDayUseCase(this.repository);

  final ProgramRepository repository;

  Future<void> call(String workoutDayId, String exerciseId) =>
      repository.removeExerciseFromDay(workoutDayId, exerciseId);
}
