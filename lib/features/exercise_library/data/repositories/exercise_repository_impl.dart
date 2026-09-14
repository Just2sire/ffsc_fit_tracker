import "../../../../shared/domain/enums/index.dart" show MuscleGroup, Equipment;
import "../../domain/entities/exercise.dart";
import "../../domain/repositories/exercise_repository.dart";
import "../datasources/exercise_local_datasource.dart";

class ExerciseRepositoryImpl implements ExerciseRepository {
  const ExerciseRepositoryImpl(this.datasource);

  final ExerciseLocalDatasource datasource;

  @override
  Future<Exercise?> getExerciseById(String id) =>
      datasource.getExerciseById(id);

  @override
  Future<List<Exercise>> getAllExercises() => datasource.getAllExercises();

  @override
  Future<List<Exercise>> searchExercises(String query) =>
      datasource.searchExercises(query);

  @override
  Future<List<Exercise>> filterExercises({
    MuscleGroup? muscle,
    Equipment? equipment,
  }) => datasource.filterExercises(muscle: muscle, equipment: equipment);
}
