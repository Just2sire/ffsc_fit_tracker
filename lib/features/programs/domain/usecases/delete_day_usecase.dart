import "../repositories/program_repository.dart";

class DeleteDayUseCase {
  const DeleteDayUseCase(this.repository);

  final ProgramRepository repository;

  Future<void> call(String id) => repository.deleteDay(id);
}
