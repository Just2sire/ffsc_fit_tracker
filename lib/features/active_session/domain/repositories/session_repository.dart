import "package:fit_tracker/features/active_session/domain/entities/exercise_set.dart";
import "package:fit_tracker/features/active_session/domain/entities/session_exercise.dart";
import "package:fit_tracker/features/active_session/domain/entities/workout_session.dart";

abstract class SessionRepository {
  Future<WorkoutSession?> findActiveSession();
  Future<WorkoutSession?> getSessionById(String id);

  Future<WorkoutSession> startSession(String workoutDayId);
  Future<WorkoutSession> pauseSession(String id);
  Future<WorkoutSession> resumeSession(String id);
  Future<WorkoutSession> completeSession(String id);
  Future<WorkoutSession> abandonSession(String id);
  Future<void> updateHeartbeat(String id);

  Future<List<SessionExercise>> getSessionExercises(String sessionId);
  Future<List<ExerciseSet>> getSetsForSessionExercise(String sessionExerciseId);
  Future<void> logSet(ExerciseSet set);
  Future<void> deleteSet(String id);

  Future<List<List<ExerciseSet>>> getExerciseHistory(
    String exerciseId, {
    int limit = 5,
  });
}
