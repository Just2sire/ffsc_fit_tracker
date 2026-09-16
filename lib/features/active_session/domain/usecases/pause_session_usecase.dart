import "../entities/workout_session.dart";
import "../repositories/session_repository.dart";

class PauseSessionUseCase {
  const PauseSessionUseCase(this.repository);

  final SessionRepository repository;

  Future<WorkoutSession> call(String id) => repository.pauseSession(id);
}
