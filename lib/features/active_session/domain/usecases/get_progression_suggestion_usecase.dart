import "../../../../core/utils/progression_engine.dart";
import "../../../../shared/domain/enums/index.dart";
import "../entities/progression_suggestion.dart";
import "../repositories/session_repository.dart";

class GetProgressionSuggestionUseCase {
  const GetProgressionSuggestionUseCase(this.repository);

  final SessionRepository repository;

  Future<ProgressionSuggestion> call({
    required String exerciseId,
    required int targetRepsMin,
    required int targetRepsMax,
    required Equipment equipment,
    required MuscleGroup primaryMuscle,
  }) async {
    final history = await repository.getExerciseHistory(exerciseId);
    return ProgressionEngine.suggest(
      pastSessions: history,
      targetRepsMin: targetRepsMin,
      targetRepsMax: targetRepsMax,
      equipment: equipment,
      primaryMuscle: primaryMuscle,
    );
  }
}
