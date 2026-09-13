import "../entities/workout_day.dart";
import "../repositories/program_repository.dart";

class WatchProgramDaysUseCase {
  const WatchProgramDaysUseCase(this.repository);

  final ProgramRepository repository;

  Stream<List<WorkoutDay>> call(String programId) =>
      repository.watchProgramDays(programId);
}
