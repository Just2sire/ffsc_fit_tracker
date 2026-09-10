import "package:fit_tracker/features/exercise_library/domain/entities/exercise.dart";
import "package:fit_tracker/features/exercise_library/domain/repositories/exercise_repository.dart";

class SearchExercisesUseCase {
  const SearchExercisesUseCase(this.repository);

  final ExerciseRepository repository;

  Future<List<Exercise>> call(String query) {
    if (query.trim().isEmpty) return repository.getAllExercises();
    return repository.searchExercises(query.trim());
  }
}
