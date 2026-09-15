import "../repositories/program_repository.dart";

class ArchiveProgramUseCase {
  const ArchiveProgramUseCase(this.repository);

  final ProgramRepository repository;

  Future<void> call(String id) => repository.archiveProgram(id);
}
