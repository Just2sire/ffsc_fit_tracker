import "../entities/program_exercise.dart";
import "../entities/workout_day.dart";
import "../entities/workout_program.dart";

abstract class ProgramRepository {
  // ─── WorkoutProgram ─────────────────────────────────

  Stream<List<WorkoutProgram>> watchAllPrograms();

  Future<List<WorkoutProgram>> getAllPrograms();

  Future<WorkoutProgram?> getProgramById(String id);

  Future<void> saveProgram(WorkoutProgram program);

  Future<void> archiveProgram(String id);

  // ─── WorkoutDay ─────────────────────────────────────

  Stream<List<WorkoutDay>> watchProgramDays(String programId);

  Stream<int> watchTotalDaysCount();

  Future<void> saveDay(WorkoutDay day);

  Future<void> deleteDay(String id);

  // ─── ProgramExercise ────────────────────────────────

  Future<List<ProgramExercise>> getExercisesForDay(String workoutDayId);

  Future<void> addExerciseToDay(ProgramExercise programExercise);

  Future<void> updateProgramExercise(ProgramExercise programExercise);

  Future<void> removeExerciseFromDay(String workoutDayId, String exerciseId);
}
