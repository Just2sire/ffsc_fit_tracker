class WorkoutDay {
  const WorkoutDay({
    required this.id,
    required this.programId,
    required this.name,
    required this.dayOrder,
    this.isArchived = false,
  });

  final String id;
  final String programId;
  final String name;
  final int dayOrder;
  final bool isArchived;
}
