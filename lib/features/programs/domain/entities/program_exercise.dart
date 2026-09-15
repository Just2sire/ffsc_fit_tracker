class ProgramExercise {
  const ProgramExercise({
    required this.id,
    required this.workoutDayId,
    required this.exerciseId,
    required this.sortOrder,
    required this.targetSets,
    required this.targetRepsMin,
    required this.targetRepsMax,
    required this.restTimeSeconds,
  });

  final String id;
  final String workoutDayId;
  final String exerciseId;
  final int sortOrder;
  final int targetSets;
  final int targetRepsMin;
  final int targetRepsMax;
  final int restTimeSeconds;
}
