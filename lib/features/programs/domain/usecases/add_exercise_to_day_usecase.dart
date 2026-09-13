import "../entities/program_exercise.dart";
import "../repositories/program_repository.dart";

class AddExerciseToDayUseCase {
  const AddExerciseToDayUseCase(this.repository);

  final ProgramRepository repository;

  Future<void> call(ProgramExercise programExercise) {
    assert(
      programExercise.targetRepsMin <= programExercise.targetRepsMax,
      "targetRepsMin must be <= targetRepsMax",
    );
    assert(
      programExercise.targetSets >= 1,
      "targetSets must be >= 1",
    );
    return repository.addExerciseToDay(programExercise);
  }
}
