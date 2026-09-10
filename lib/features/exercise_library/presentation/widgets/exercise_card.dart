import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/extensions/string_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../domain/entities/exercise.dart";

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
    this.useHero = false,
  });
  final Exercise exercise;
  final VoidCallback onTap;
  final bool useHero;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.roundedLg,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedLg,
          side: BorderSide(color: colorScheme.outline),
        ),
        elevation: AppSpacing.elevationMd,
        margin: .zero,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Hero(
                tag: exercise.id,
                child: ClipRRect(
                  borderRadius: AppSpacing.roundedLg,
                  child: Image.asset(
                    exercise.imageAsset,
                    fit: .fitWidth,
                    errorBuilder: (context, error, stackTrace) {
                      return ColoredBox(
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          LucideIcons.sportShoe,
                          size: AppSpacing.iconXl,
                          color: colorScheme.primary,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsGeometry.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    exercise.name.capitalize,
                    style: textTheme.bodyLarge!.copyWith(fontWeight: .bold),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  Row(
                    spacing: AppSpacing.sm,
                    children: [
                      Icon(
                        LucideIcons.bicepsFlexed,
                        color: colorScheme.onSurface,
                        size: AppSpacing.iconMd,
                      ),
                      Expanded(
                        child: Text(
                          exercise.primaryMuscle.label.capitalize,
                          style: textTheme.bodySmall,
                          overflow: .ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // return InkWell(
    //   onTap: onTap,
    //   borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
    //   child: Container(
    //     padding: AppSpacing.cardPadding,
    //     decoration: BoxDecoration(
    //       color: colorScheme.surfaceContainerLow,
    //       borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
    //     ),
    //     child: Row(
    //       children: [
    //         ClipRRect(
    //           borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
    //           child: Image.asset(
    //             exercise.imageAsset,
    //             width: 56,
    //             height: 56,
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //         AppSpacing.gapHMd,
    //         Expanded(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(exercise.name, style: context.textTheme.titleMedium),
    //               AppSpacing.gapVXs,
    //               Text(
    //                 exercise.primaryMuscle.label,
    //                 style: context.textTheme.bodyMedium?.copyWith(
    //                   color: colorScheme.onSurfaceVariant,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Icon(Icons.chevron_right, color: colorScheme.outlineVariant),
    //       ],
    //     ),
    //   ),
    // );
  }
}
