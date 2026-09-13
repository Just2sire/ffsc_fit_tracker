import "package:fit_tracker/features/exercise_library/data/datasources/exercise_local_datasource.dart";
import "package:fit_tracker/features/exercise_library/domain/entities/exercise.dart";
import "package:fit_tracker/features/exercise_library/domain/repositories/exercise_repository.dart";
import "package:fit_tracker/shared/domain/enums/equipment.dart";
import "package:fit_tracker/shared/domain/enums/muscle_group.dart";

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
