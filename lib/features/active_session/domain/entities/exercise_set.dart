class ExerciseSet {
  const ExerciseSet({
    required this.id,
    required this.sessionExerciseId,
    required this.setNumber,
    required this.weight,
    required this.reps,
    required this.isCompleted,
    this.targetReps,
    this.targetWeight,
    this.rpe,
    this.notes,
    this.completedAt,
  });

  final String id;
  final String sessionExerciseId;
  final int setNumber;
  final double weight;
  final int reps;
  final bool isCompleted;
  final String? targetReps;
  final double? targetWeight;
  final int? rpe;
  final String? notes;
  final DateTime? completedAt;

  ExerciseSet copyWith({
    double? weight,
    int? reps,
    bool? isCompleted,
    String? targetReps,
    double? targetWeight,
    int? rpe,
    String? notes,
    DateTime? completedAt,
  }) {
    return ExerciseSet(
      id: id,
      sessionExerciseId: sessionExerciseId,
      setNumber: setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      isCompleted: isCompleted ?? this.isCompleted,
      targetReps: targetReps ?? this.targetReps,
      targetWeight: targetWeight ?? this.targetWeight,
      rpe: rpe ?? this.rpe,
      notes: notes ?? this.notes,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
