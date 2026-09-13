import "../../../../shared/data/database/app_database.dart";
import "../../../../shared/domain/enums/equipment.dart";
import "../../../../shared/domain/enums/muscle_group.dart";
import "../../domain/entities/exercise.dart" as entity;

class ExerciseLocalDatasource {
  const ExerciseLocalDatasource(this._database);
  final AppDatabase _database;

  Future<entity.Exercise?> getExerciseById(String id) async {
    final row = await _database.exerciseDao.getExerciseById(id);
    return row == null ? null : _toDomain(row);
  }

  Future<List<entity.Exercise>> getAllExercises() async {
    final rows = await _database.exerciseDao.getAllExercises();
    return rows.map(_toDomain).toList();
  }

  Future<List<entity.Exercise>> searchExercises(String query) async {
    final rows = await _database.exerciseDao.searchExercises(query);
    return rows.map(_toDomain).toList();
  }

  Future<List<entity.Exercise>> filterExercises({
    MuscleGroup? muscle,
    Equipment? equipment,
  }) async {
    final rows = await _database.exerciseDao.filterExercises(
      muscle: muscle,
      equipment: equipment,
    );
    return rows.map(_toDomain).toList();
  }

  entity.Exercise _toDomain(Exercise row) {
    return entity.Exercise(
      id: row.id,
      name: row.name,
      primaryMuscle: row.muscleGroup,
      secondaryMuscles: row.secondaryMuscles,
      equipment: row.equipment,
      instructions: row.instructionSteps,
      imageAsset: row.imageAsset,
      videoAsset: row.videoAsset,
      isArchived: row.isArchived,
    );
  }
}
