import "package:fit_tracker/shared/domain/enums/equipment.dart";
import "package:fit_tracker/shared/domain/enums/muscle_group.dart";

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    required this.equipment,
    required this.instructions,
    required this.imageAsset,
    required this.videoAsset,
    this.isArchived = false,
  });

  final String id;
  final String name;
  final MuscleGroup primaryMuscle;
  final List<String> secondaryMuscles;
  final Equipment equipment;
  final List<String> instructions;
  final String imageAsset;
  final String videoAsset;
  final bool isArchived;
}
