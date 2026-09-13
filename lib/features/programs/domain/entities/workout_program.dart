
import "../../../../shared/domain/enums/training_goal.dart";

class WorkoutProgram {
  const WorkoutProgram({
    required this.id,
    required this.name,
    required this.goal,
    this.isArchived = false,
  });

  final String id;
  final String name;
  final TrainingGoal goal;
  final bool isArchived;
}
