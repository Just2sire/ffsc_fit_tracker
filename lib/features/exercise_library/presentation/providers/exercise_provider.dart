import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/domain/enums/equipment.dart";
import "../../../../shared/domain/enums/muscle_group.dart";
import "../../../../shared/presentation/providers/database_providers.dart";
import "../../data/datasources/exercise_local_datasource.dart";
import "../../data/repositories/exercise_repository_impl.dart";
import "../../domain/entities/exercise.dart";
import "../../domain/repositories/exercise_repository.dart";

part "exercise_provider.g.dart";

@riverpod
ExerciseRepository exerciseRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final datasource = ExerciseLocalDatasource(db);
  return ExerciseRepositoryImpl(datasource);
}

@riverpod
Future<Exercise?> exerciseById(Ref ref, String id) {
  return ref.watch(exerciseRepositoryProvider).getExerciseById(id);
}

@riverpod
class ExercisesList extends _$ExercisesList {
  @override
  Future<List<Exercise>> build() {
    return ref.watch(exerciseRepositoryProvider).getAllExercises();
  }

  Future<void> refresh() => ref.refresh(exercisesListProvider.future);
}

@riverpod
class ExerciseSearchQuery extends _$ExerciseSearchQuery {
  @override
  String build() => "";

  Future<void> set(String value) async => state = value;
}

@riverpod
class MuscleFilter extends _$MuscleFilter {
  @override
  Set<MuscleGroup> build() => const {};

  Future<void> set(Set<MuscleGroup> value) async => state = value;

  Future<void> clear() async => state = const {};
}

@riverpod
class EquipmentFilter extends _$EquipmentFilter {
  @override
  Set<Equipment> build() => const {};

  Future<void> set(Set<Equipment> value) async => state = value;

  Future<void> clear() async => state = const {};
}

@riverpod
Future<List<Exercise>> filteredExercises(Ref ref) async {
  final all = await ref.watch(exercisesListProvider.future);
  final query = ref.watch(exerciseSearchQueryProvider).toLowerCase();
  final muscles = ref.watch(muscleFilterProvider);
  final equipments = ref.watch(equipmentFilterProvider);

  return all.where((e) {
    final matchesQuery = query.isEmpty || e.name.toLowerCase().contains(query);
    final matchesMuscle = muscles.isEmpty || muscles.contains(e.primaryMuscle);
    final matchesEquipment =
        equipments.isEmpty || equipments.contains(e.equipment);
    return matchesQuery && matchesMuscle && matchesEquipment;
  }).toList();
}
