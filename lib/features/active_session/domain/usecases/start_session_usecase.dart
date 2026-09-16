import "../entities/workout_session.dart";
import "../repositories/session_repository.dart";

class StartSessionUseCase {
  const StartSessionUseCase(this.repository);

  final SessionRepository repository;

  Future<WorkoutSession> call(String workoutDayId) =>
      repository.startSession(workoutDayId);
}
