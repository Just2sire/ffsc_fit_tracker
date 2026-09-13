import "../entities/program_exercise.dart";
import "../repositories/program_repository.dart";

class GetExercisesForDayUseCase {
  const GetExercisesForDayUseCase(this.repository);

  final ProgramRepository repository;

  Future<List<ProgramExercise>> call(String workoutDayId) =>
      repository.getExercisesForDay(workoutDayId);
}
