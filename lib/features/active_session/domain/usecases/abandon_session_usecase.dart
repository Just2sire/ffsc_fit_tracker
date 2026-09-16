import "../entities/workout_session.dart";
import "../repositories/session_repository.dart";

class AbandonSessionUseCase {
  const AbandonSessionUseCase(this.repository);

  final SessionRepository repository;

  Future<WorkoutSession> call(String id) => repository.abandonSession(id);
}
