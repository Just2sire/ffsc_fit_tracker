import "../entities/workout_session.dart";
import "../repositories/session_repository.dart";

class CompleteSessionUseCase {
  const CompleteSessionUseCase(this.repository);

  final SessionRepository repository;

  Future<WorkoutSession> call(String id) => repository.completeSession(id);
}
