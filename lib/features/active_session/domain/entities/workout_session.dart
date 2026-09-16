import "package:fit_tracker/shared/domain/enums/index.dart";

class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.workoutDayId,
    required this.workoutDayNameSnapshot,
    required this.status,
    required this.startedAt,
    required this.lastActiveAt,
    required this.pausedDurationSeconds,
    this.finishedAt,
  });

  final String id;
  final String workoutDayId;
  final String workoutDayNameSnapshot;
  final SessionStatus status;
  final DateTime startedAt;
  final DateTime lastActiveAt;
  final int pausedDurationSeconds;
  final DateTime? finishedAt;
}
