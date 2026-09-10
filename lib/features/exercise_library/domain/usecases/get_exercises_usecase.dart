import "package:fit_tracker/features/exercise_library/domain/entities/exercise.dart";
import "package:fit_tracker/features/exercise_library/domain/repositories/exercise_repository.dart";

class GetExercisesUseCase {
  const GetExercisesUseCase(this.repository);

  final ExerciseRepository repository;

  Future<List<Exercise>> call() => repository.getAllExercises();
}
