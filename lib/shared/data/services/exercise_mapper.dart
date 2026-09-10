
import "../../domain/enums/index.dart" show MuscleGroup, Equipment;

class ExerciseMapper {
  ExerciseMapper._();

  static MuscleGroup parseMuscleGroup(String target) {
    try {
      return MuscleGroup.fromLabel(target);
    } catch (_) {
      throw ArgumentError('Muscle group non mappé dans le JSON: "$target"');
    }
  }

  static Equipment parseEquipment(String equipment) {
    try {
      return Equipment.fromLabel(equipment);
    } catch (_) {
      throw ArgumentError('Équipement non mappé dans le JSON: "$equipment"');
    }
  }
}
