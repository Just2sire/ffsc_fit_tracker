import "../entities/workout_session.dart";
import "../repositories/session_repository.dart";

class ResumeSessionUseCase {
  const ResumeSessionUseCase(this.repository);

  final SessionRepository repository;

  Future<WorkoutSession> call(String id) => repository.resumeSession(id);
}
