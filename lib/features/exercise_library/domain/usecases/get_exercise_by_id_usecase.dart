import "package:fit_tracker/features/exercise_library/domain/entities/exercise.dart";
import "package:fit_tracker/features/exercise_library/domain/repositories/exercise_repository.dart";

class GetExerciseByIdUseCase {
  const GetExerciseByIdUseCase(this.repository);

  final ExerciseRepository repository;

  Future<Exercise?> call(String id) => repository.getExerciseById(id);
}
