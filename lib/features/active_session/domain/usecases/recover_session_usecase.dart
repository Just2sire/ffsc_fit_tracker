import "../entities/workout_session.dart";
import "../repositories/session_repository.dart";

class RecoverSessionUseCase {
  const RecoverSessionUseCase(this.repository);

  static const staleAfter = Duration(hours: 24);

  final SessionRepository repository;

  Future<WorkoutSession?> call() async {
    final session = await repository.findActiveSession();
    if (session == null) return null;

    final elapsed = DateTime.now().difference(session.lastActiveAt);
    if (elapsed > staleAfter) {
      await repository.abandonSession(session.id);
      return null;
    }
    return session;
  }
}
