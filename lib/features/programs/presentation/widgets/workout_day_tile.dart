import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../providers/program_provider.dart";
import "program_exercise_tile.dart";

/// Tile expandable affichant un jour d'entraînement et sa liste d'exercices.
class WorkoutDayTile extends StatelessWidget {
  const WorkoutDayTile({
    super.key,
    required this.dayId,
    required this.dayOrder,
    required this.dayName,
  });

  final String dayId;
  final int dayOrder;
  final String dayName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return ClipRRect(
      borderRadius: AppSpacing.roundedLg,
      child: ExpansionTile(
        leading: _DayBadge(order: dayOrder + 1),
        title: Text(
          dayName,
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedLg,
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedLg,
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        backgroundColor: colorScheme.surfaceContainer,
        collapsedBackgroundColor: colorScheme.surfaceContainer,
        iconColor: colorScheme.accentForeground,
        collapsedIconColor: colorScheme.onSurfaceVariant,
        childrenPadding: EdgeInsets.zero,
        children: [
          Divider(height: 1, color: colorScheme.outlineVariant),
          Consumer(
            builder: (context, ref, _) {
              final exercisesAsync = ref.watch(
                exercisesForDayProvider(dayId),
              );
              return exercisesAsync.when(
                data: (exercises) {
                  if (exercises.isEmpty) {
                    return Padding(
                      padding: AppSpacing.insetMd,
                      child: Row(
                        spacing: AppSpacing.sm,
                        children: [
                          Icon(
                            LucideIcons.info,
                            size: AppSpacing.iconSm,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          Text(
                            "Aucun exercice dans ce jour",
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (var i = 0; i < exercises.length; i++)
                        ProgramExerciseTile(
                          exercise: exercises[i],
                          showDivider: i < exercises.length - 1,
                        ),
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                error: (e, _) => Padding(
                  padding: AppSpacing.insetMd,
                  child: Text(
                    "Erreur : $e",
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DayBadge extends StatelessWidget {
  const _DayBadge({required this.order});

  final int order;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Container(
      width: AppSpacing.avatarSm,
      height: AppSpacing.avatarSm,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Text(
        "$order",
        style: context.textTheme.labelMedium?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
