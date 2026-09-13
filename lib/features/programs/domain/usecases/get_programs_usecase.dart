import "../entities/workout_program.dart";
import "../repositories/program_repository.dart";

class GetProgramsUseCase {
  const GetProgramsUseCase(this.repository);

  final ProgramRepository repository;

  Future<List<WorkoutProgram>> call() => repository.getAllPrograms();
}
