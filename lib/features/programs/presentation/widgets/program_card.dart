import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/domain/enums/training_goal.dart";
import "../../domain/entities/workout_program.dart";

class ProgramCard extends StatelessWidget {
  const ProgramCard({
    super.key,
    required this.program,
    required this.onTap,
    this.onArchive,
  });

  final WorkoutProgram program;
  final VoidCallback onTap;
  final VoidCallback? onArchive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.roundedXl,
      child: Container(
        padding: AppSpacing.cardPaddingCompact,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: AppSpacing.roundedXl,
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: AppSpacing.avatarMd,
              height: AppSpacing.avatarMd,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: goalBgColor(program.goal),
                borderRadius: AppSpacing.roundedMd,
              ),
              child: Icon(
                goalIcon(program.goal),
                size: AppSpacing.iconMd,
                color: goalColor(program.goal),
              ),
            ),
            AppSpacing.gapHMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xs,
                children: [
                  Text(
                    program.name,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  GoalChip(goal: program.goal),
                ],
              ),
            ),
            AppSpacing.gapHSm,
            if (onArchive != null)
              PopupMenuButton<_ProgramAction>(
                onSelected: (action) {
                  if (action == _ProgramAction.archive) onArchive?.call();
                },
                icon: Icon(
                  LucideIcons.ellipsisVertical,
                  size: AppSpacing.iconMd,
                  color: colorScheme.onSurfaceVariant,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _ProgramAction.archive,
                    child: Row(
                      spacing: AppSpacing.sm,
                      children: [
                        Icon(
                          LucideIcons.archive,
                          size: AppSpacing.iconSm,
                          color: colorScheme.error,
                        ),
                        Text(
                          "Archiver",
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              Icon(
                LucideIcons.chevronRight,
                size: AppSpacing.iconMd,
                color: colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }

  static Color goalColor(TrainingGoal goal) => switch (goal) {
    TrainingGoal.strength => AppColors.tagAmber,
    TrainingGoal.hypertrophy => AppColors.tagPurple,
    TrainingGoal.endurance => AppColors.tagGreen,
    TrainingGoal.weightLoss => AppColors.tagBlue,
    TrainingGoal.generalFitness => AppColors.tagCyan,
  };

  static Color goalBgColor(TrainingGoal goal) => switch (goal) {
    TrainingGoal.strength => AppColors.tagAmberBg,
    TrainingGoal.hypertrophy => AppColors.tagPurpleBg,
    TrainingGoal.endurance => AppColors.tagGreenBg,
    TrainingGoal.weightLoss => AppColors.tagBlueBg,
    TrainingGoal.generalFitness => AppColors.tagCyanBg,
  };

  static IconData goalIcon(TrainingGoal goal) => switch (goal) {
    TrainingGoal.strength => LucideIcons.zap,
    TrainingGoal.hypertrophy => LucideIcons.bicepsFlexed,
    TrainingGoal.endurance => LucideIcons.heartPulse,
    TrainingGoal.weightLoss => LucideIcons.flame,
    TrainingGoal.generalFitness => LucideIcons.activity,
  };
}

enum _ProgramAction { archive }

/// Chip colorée affichant l'objectif d'entraînement.
/// Réutilisable dans la page détail et l'éditeur.
class GoalChip extends StatelessWidget {
  const GoalChip({super.key, required this.goal});

  final TrainingGoal goal;

  @override
  Widget build(BuildContext context) {
    final color = ProgramCard.goalColor(goal);
    final bg = ProgramCard.goalBgColor(goal);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppSpacing.roundedFull,
      ),
      child: Text(
        goal.label,
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
