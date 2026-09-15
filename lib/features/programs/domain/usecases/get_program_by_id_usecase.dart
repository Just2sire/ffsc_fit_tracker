import "../entities/workout_program.dart";
import "../repositories/program_repository.dart";

class GetProgramByIdUseCase {
  const GetProgramByIdUseCase(this.repository);

  final ProgramRepository repository;

  Future<WorkoutProgram?> call(String id) => repository.getProgramById(id);
}
