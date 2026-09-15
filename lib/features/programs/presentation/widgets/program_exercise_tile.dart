import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/extensions/string_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../exercise_library/presentation/providers/exercise_provider.dart";
import "../../domain/entities/program_exercise.dart";

class ProgramExerciseTile extends ConsumerWidget {
  const ProgramExerciseTile({
    super.key,
    required this.exercise,
    this.showDivider = false,
    this.showDragHandle = false,
    this.onDelete,
  });

  final ProgramExercise exercise;
  final bool showDivider;
  final bool showDragHandle;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final exerciseAsync = ref.watch(exerciseByIdProvider(exercise.exerciseId));
    final exerciseName = switch (exerciseAsync) {
      AsyncData(value: final e) when e != null => e.name.capitalizeWords,
      AsyncError() => "Exercice introuvable",
      _ => "…",
    };

    final prescription =
        "${exercise.targetSets} séries · "
        "${exercise.targetRepsMin}–${exercise.targetRepsMax} reps · "
        "${exercise.restTimeSeconds}s repos";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: AppSpacing.listItemPaddingSm,
          child: Row(
            children: [
              if (showDragHandle) ...[
                Icon(
                  LucideIcons.gripVertical,
                  size: AppSpacing.iconMd,
                  color: colorScheme.onSurfaceVariant,
                ),
                AppSpacing.gapHSm,
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xs,
                  children: [
                    Text(
                      exerciseName,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      prescription,
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    LucideIcons.trash2,
                    size: AppSpacing.iconSm,
                    color: colorScheme.error,
                  ),
                ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: AppSpacing.lg,
            endIndent: AppSpacing.lg,
            color: colorScheme.outlineVariant,
          ),
      ],
    );
  }
}
