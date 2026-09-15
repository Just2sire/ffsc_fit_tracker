import "../entities/workout_day.dart";
import "../repositories/program_repository.dart";

class SaveDayUseCase {
  const SaveDayUseCase(this.repository);

  final ProgramRepository repository;

  Future<void> call(WorkoutDay day) => repository.saveDay(day);
}
