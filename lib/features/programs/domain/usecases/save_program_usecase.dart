import "../entities/workout_program.dart";
import "../repositories/program_repository.dart";

class SaveProgramUseCase {
  const SaveProgramUseCase(this.repository);

  final ProgramRepository repository;

  Future<void> call(WorkoutProgram program) => repository.saveProgram(program);
}
