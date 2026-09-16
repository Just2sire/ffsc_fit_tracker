import "package:fit_tracker/features/active_session/domain/entities/exercise_set.dart";
import "package:fit_tracker/features/active_session/domain/entities/progression_suggestion.dart";
import "package:fit_tracker/shared/domain/enums/equipment.dart";
import "package:fit_tracker/shared/domain/enums/muscle_group.dart";

enum _SessionScore { success, partial, failure }

class ProgressionEngine {
  const ProgressionEngine._();

  static const _barbellLike = {
    Equipment.barbell,
    Equipment.ezBar,
    Equipment.olympicBarbell,
    Equipment.trapBar,
    Equipment.smithMachine,
  };

  static const _lowerBody = {
    MuscleGroup.quadriceps,
    MuscleGroup.hamstrings,
    MuscleGroup.glutes,
    MuscleGroup.calves,
    MuscleGroup.adductors,
    MuscleGroup.abductors,
  };

  static ProgressionSuggestion suggest({
    required List<List<ExerciseSet>> pastSessions,
    required int targetRepsMin,
    required int targetRepsMax,
    required Equipment equipment,
    required MuscleGroup primaryMuscle,
  }) {
    if (pastSessions.isEmpty) {
      return const ProgressionSuggestion(
        trend: ProgressionTrend.noHistory,
        rationale: "Aucun historique",
      );
    }

    final lastSession = pastSessions.first;
    final baseWeight = lastSession.map((s) => s.weight).reduce(
      (a, b) => a > b ? a : b,
    );

    if (pastSessions.length == 1) {
      return ProgressionSuggestion(
        trend: ProgressionTrend.firstReference,
        suggestedWeight: baseWeight,
        rationale: "Première référence",
      );
    }

    final lastScore = _score(lastSession, targetRepsMin, targetRepsMax);
    final previousScore = _score(
      pastSessions[1],
      targetRepsMin,
      targetRepsMax,
    );

    if (lastScore == _SessionScore.success &&
        previousScore == _SessionScore.success) {
      final increment = _incrementFor(equipment, primaryMuscle, baseWeight);
      return ProgressionSuggestion(
        trend: ProgressionTrend.increase,
        suggestedWeight: baseWeight + increment,
        rationale: "Progression",
      );
    }

    if (lastScore == _SessionScore.failure &&
        previousScore == _SessionScore.failure) {
      final reduced = ((baseWeight * 0.95) * 2).round() / 2;
      return ProgressionSuggestion(
        trend: ProgressionTrend.decrease,
        suggestedWeight: reduced,
        rationale: "Charge réduite",
      );
    }

    return ProgressionSuggestion(
      trend: ProgressionTrend.same,
      suggestedWeight: baseWeight,
      rationale: "Même charge",
    );
  }

  static _SessionScore _score(List<ExerciseSet> sets, int min, int max) {
    if (sets.isEmpty) return _SessionScore.failure;
    if (sets.every((s) => s.reps >= max)) return _SessionScore.success;
    if (sets.any((s) => s.reps >= min)) return _SessionScore.partial;
    return _SessionScore.failure;
  }

  static double _incrementFor(
    Equipment equipment,
    MuscleGroup muscle,
    double baseWeight,
  ) {
    if (equipment == Equipment.dumbbell) {
      return baseWeight <= 20 ? 1 : 2;
    }
    if (_barbellLike.contains(equipment)) {
      return _lowerBody.contains(muscle) ? 5 : 2.5;
    }
    return 2.5;
  }
}
