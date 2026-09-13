import "../entities/workout_program.dart";
import "../repositories/program_repository.dart";

class WatchProgramsUseCase {
  const WatchProgramsUseCase(this.repository);

  final ProgramRepository repository;

  Stream<List<WorkoutProgram>> call() => repository.watchAllPrograms();
}
