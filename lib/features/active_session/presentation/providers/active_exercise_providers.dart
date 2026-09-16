import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

import "../../domain/entities/exercise_set.dart";
import "../../domain/entities/progression_suggestion.dart";
import "../../domain/entities/session_exercise.dart";
import "../../domain/entities/session_exercise_target.dart";
import "../../domain/usecases/get_progression_suggestion_usecase.dart";
import "active_session_notifier.dart";

part "active_exercise_providers.g.dart";

@riverpod
Future<List<SessionExercise>> sessionExercises(Ref ref) async {
  final session = await ref.watch(activeSessionProvider.future);
  if (session == null) return [];
  return ref.watch(sessionRepositoryProvider).getSessionExercises(session.id);
}

@riverpod
class CurrentExerciseIndex extends _$CurrentExerciseIndex {
  @override
  int build() {
    ref.watch(activeSessionProvider);
    return 0;
  }

  Future<void> next() async {
    final total = (await ref.read(sessionExercisesProvider.future)).length;
    if (total == 0) return;
    state = (state + 1) % total;
  }

  Future<void> previous() async {
    final total = (await ref.read(sessionExercisesProvider.future)).length;
    if (total == 0) return;
    state = (state - 1 + total) % total;
  }
}

@riverpod
Future<SessionExercise?> currentSessionExercise(Ref ref) async {
  final list = await ref.watch(sessionExercisesProvider.future);
  if (list.isEmpty) return null;
  final index = ref.watch(currentExerciseIndexProvider);
  return list[index.clamp(0, list.length - 1)];
}

@riverpod
Future<SessionExerciseTarget?> currentExerciseTarget(Ref ref) async {
  final session = await ref.watch(activeSessionProvider.future);
  final current = await ref.watch(currentSessionExerciseProvider.future);
  if (session == null || current == null) return null;
  return ref
      .watch(sessionRepositoryProvider)
      .getTargetForExercise(session.workoutDayId, current.exerciseId);
}

@riverpod
Future<List<List<ExerciseSet>>> currentExerciseHistory(Ref ref) async {
  final current = await ref.watch(currentSessionExerciseProvider.future);
  if (current == null) return [];
  return ref
      .watch(sessionRepositoryProvider)
      .getExerciseHistory(current.exerciseId);
}

@riverpod
Future<ProgressionSuggestion?> currentProgressionSuggestion(Ref ref) async {
  final current = await ref.watch(currentSessionExerciseProvider.future);
  final target = await ref.watch(currentExerciseTargetProvider.future);
  if (current == null || target == null) return null;

  final repository = ref.watch(sessionRepositoryProvider);
  return GetProgressionSuggestionUseCase(repository).call(
    exerciseId: current.exerciseId,
    targetRepsMin: target.targetRepsMin,
    targetRepsMax: target.targetRepsMax,
    equipment: current.equipmentSnapshot,
    primaryMuscle: current.primaryMuscleSnapshot,
  );
}

@riverpod
class CurrentExerciseSets extends _$CurrentExerciseSets {
  static const _uuid = Uuid();

  @override
  Future<List<ExerciseSet>> build() async {
    final current = await ref.watch(currentSessionExerciseProvider.future);
    if (current == null) return [];
    return ref
        .watch(sessionRepositoryProvider)
        .getSetsForSessionExercise(current.id);
  }

  Future<void> logSet(ExerciseSet set) async {
    await ref.read(sessionRepositoryProvider).logSet(set);
    ref.invalidateSelf();
    await future;
  }

  Future<void> toggleCompleted(String setId) async {
    final sets = state.value ?? [];
    final target = sets.firstWhere((s) => s.id == setId);
    await logSet(
      target.copyWith(
        isCompleted: !target.isCompleted,
        completedAt: !target.isCompleted ? DateTime.now() : null,
      ),
    );
  }

  Future<void> addSet({required double weight, String? targetReps}) async {
    final current = await ref.read(currentSessionExerciseProvider.future);
    if (current == null) return;
    final sets = state.value ?? [];
    await logSet(
      ExerciseSet(
        id: _uuid.v4(),
        sessionExerciseId: current.id,
        setNumber: sets.length + 1,
        weight: weight,
        reps: 0,
        isCompleted: false,
        targetReps: targetReps,
      ),
    );
  }

  Future<void> deleteSet(String setId) async {
    await ref.read(sessionRepositoryProvider).deleteSet(setId);
    ref.invalidateSelf();
    await future;
  }
}
