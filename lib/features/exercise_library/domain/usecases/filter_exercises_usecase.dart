import "package:fit_tracker/features/exercise_library/domain/entities/exercise.dart";
import "package:fit_tracker/features/exercise_library/domain/repositories/exercise_repository.dart";
import "package:fit_tracker/shared/domain/enums/equipment.dart";
import "package:fit_tracker/shared/domain/enums/muscle_group.dart";

class FilterExercisesUseCase {
  const FilterExercisesUseCase(this.repository);

  final ExerciseRepository repository;

  Future<List<Exercise>> call({MuscleGroup? muscle, Equipment? equipment}) =>
      repository.filterExercises(muscle: muscle, equipment: equipment);
}
