import "../../../../shared/domain/enums/equipment.dart";
import "../../../../shared/domain/enums/muscle_group.dart";
import "../entities/exercise.dart";

abstract class ExerciseRepository {
  Future<Exercise?> getExerciseById(String id);
  Future<List<Exercise>> getAllExercises();
  Future<List<Exercise>> searchExercises(String query);
  Future<List<Exercise>> filterExercises({
    MuscleGroup? muscle,
    Equipment? equipment,
  });
}
