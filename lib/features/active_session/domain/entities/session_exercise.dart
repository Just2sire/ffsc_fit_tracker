import "../../../../shared/domain/enums/index.dart";

class SessionExercise {
  const SessionExercise({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.exerciseNameSnapshot,
    required this.equipmentSnapshot,
    required this.primaryMuscleSnapshot,
    required this.sortOrder,
  });

  final String id;
  final String sessionId;
  final String exerciseId;
  final String exerciseNameSnapshot;
  final Equipment equipmentSnapshot;
  final MuscleGroup primaryMuscleSnapshot;
  final int sortOrder;
}
