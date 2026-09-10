import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/domain/enums/muscle_group.dart";
import "../providers/exercise_provider.dart";

class ExerciseFilterBar extends ConsumerWidget {
  const ExerciseFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(muscleFilterProvider);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: MuscleGroup.values.length,
        separatorBuilder: (_, _) => AppSpacing.gapHSm,
        itemBuilder: (context, index) {
          final muscle = MuscleGroup.values[index];
          final isSelected = selected == muscle;
          return ChoiceChip(
            label: Text(muscle.label),
            selected: isSelected,
            onSelected: (_) => ref
                .read(muscleFilterProvider.notifier)
                .set(isSelected ? null : muscle),
          );
        },
      ),
    );
  }
}
