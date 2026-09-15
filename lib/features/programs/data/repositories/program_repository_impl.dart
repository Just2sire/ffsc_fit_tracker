import "../../domain/entities/index.dart";
import "../../domain/repositories/program_repository.dart";
import "../datasources/program_local_datasource.dart";

class ProgramRepositoryImpl implements ProgramRepository {
  const ProgramRepositoryImpl(this.datasource);

  final ProgramLocalDatasource datasource;

  @override
  Stream<List<WorkoutProgram>> watchAllPrograms() =>
      datasource.watchAllPrograms();

  @override
  Future<List<WorkoutProgram>> getAllPrograms() => datasource.getAllPrograms();

  @override
  Future<WorkoutProgram?> getProgramById(String id) =>
      datasource.getProgramById(id);

  @override
  Future<void> saveProgram(WorkoutProgram program) =>
      datasource.saveProgram(program);

  @override
  Future<void> archiveProgram(String id) => datasource.archiveProgram(id);

  @override
  Stream<List<WorkoutDay>> watchProgramDays(String programId) =>
      datasource.watchProgramDays(programId);

  @override
  Stream<int> watchTotalDaysCount() => datasource.watchTotalDaysCount();

  @override
  Future<void> saveDay(WorkoutDay day) => datasource.saveDay(day);

  @override
  Future<void> deleteDay(String id) => datasource.deleteDay(id);

  @override
  Future<List<ProgramExercise>> getExercisesForDay(String workoutDayId) =>
      datasource.getExercisesForDay(workoutDayId);

  @override
  Future<void> addExerciseToDay(ProgramExercise programExercise) =>
      datasource.addExerciseToDay(programExercise);

  @override
  Future<void> updateProgramExercise(ProgramExercise programExercise) =>
      datasource.updateProgramExercise(programExercise);

  @override
  Future<void> removeExerciseFromDay(
    String workoutDayId,
    String exerciseId,
  ) => datasource.removeExerciseFromDay(workoutDayId, exerciseId);
}
