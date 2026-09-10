import "package:fit_tracker/features/exercise_library/presentation/providers/exercise_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/extensions/color_extension.dart";
import "../../../../core/extensions/string_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppDivider, AppScaffold, ExerciseVideoPlayer;

class ExerciseDetailPage extends ConsumerWidget {
  const ExerciseDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseById = ref.watch(exerciseByIdProvider(id));

    return AppScaffold(
      scrollable: true,
      padding: EdgeInsets.zero,
      body: exerciseById.when(
        data: (exercise) {
          if (exercise == null) {
            return _NotFound(onBack: () => context.pop());
          }

          final colorScheme = context.colorScheme;
          final textTheme = context.textTheme;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: exercise.id,
                    child: ExerciseVideoPlayer(assetPath: exercise.videoAsset),
                  ),
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    child: _BackButton(onTap: () => context.pop()),
                  ),
                ],
              ),
              Padding(
                padding: AppSpacing.screenPaddingH.copyWith(
                  top: AppSpacing.lg,
                  bottom: AppSpacing.xxxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name.capitalizeWords,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.gapVLg,
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        _InfoBadge(
                          icon: LucideIcons.target,
                          label: exercise.primaryMuscle.label.capitalize,
                          background: colorScheme.primaryContainer,
                          foreground: colorScheme.onPrimaryContainer,
                        ),
                        _InfoBadge(
                          icon: LucideIcons.dumbbell,
                          label: exercise.equipment.label.capitalize,
                          background: colorScheme.surfaceContainer,
                          foreground: colorScheme.onSurface,
                          borderColor: colorScheme.outlineVariant,
                        ),
                      ],
                    ),
                    if (exercise.secondaryMuscles.isNotEmpty) ...[
                      AppSpacing.gapVXl,
                      Text(
                        "Muscles secondaires",
                        style: textTheme.titleSmall,
                      ),
                      AppSpacing.gapVSm,
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: exercise.secondaryMuscles
                            .map(
                              (muscle) => _OutlineChip(
                                label: muscle.capitalize,
                                borderColor: colorScheme.outlineVariant,
                                textColor: colorScheme.onSurfaceVariant,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    AppSpacing.gapVXxl,
                    const AppDivider(),
                    AppSpacing.gapVLg,
                    Row(
                      children: [
                        Icon(
                          LucideIcons.listChecks,
                          size: AppSpacing.iconMd,
                          color: colorScheme.onSurface,
                        ),
                        AppSpacing.gapHSm,
                        Text(
                          "Instructions",
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapVLg,
                    ...exercise.instructions.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.lg,
                        ),
                        child: _InstructionStep(
                          number: entry.key + 1,
                          text: entry.value,
                          badgeColor: colorScheme.primaryContainer,
                          numberColor: colorScheme.onPrimaryContainer,
                          textColor: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _NotFound(
          onBack: () => context.pop(),
          message: "Erreur : $error",
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return SafeArea(
      bottom: false,
      child: Material(
        color: colorScheme.inverseSurface.addOpacity(0.7),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: AppSpacing.insetSm,
            child: Icon(
              LucideIcons.arrowLeft,
              size: AppSpacing.iconLg,
              color: colorScheme.onInverseSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    this.borderColor,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.chipPadding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppSpacing.roundedFull,
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSpacing.iconSm, color: foreground),
          AppSpacing.gapHSm,
          Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}

class _OutlineChip extends StatelessWidget {
  const _OutlineChip({
    required this.label,
    required this.borderColor,
    required this.textColor,
  });

  final String label;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.chipPadding,
      decoration: BoxDecoration(
        borderRadius: AppSpacing.roundedFull,
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: context.textTheme.labelMedium?.copyWith(color: textColor),
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  const _InstructionStep({
    required this.number,
    required this.text,
    required this.badgeColor,
    required this.numberColor,
    required this.textColor,
  });

  final int number;
  final String text;
  final Color badgeColor;
  final Color numberColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppSpacing.avatarXs,
          height: AppSpacing.avatarXs,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
          child: Text(
            "$number",
            style: context.textTheme.labelLarge?.copyWith(
              color: numberColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AppSpacing.gapHMd,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              text,
              style: context.textTheme.bodyLarge?.copyWith(color: textColor),
            ),
          ),
        ),
      ],
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.onBack, this.message});

  final VoidCallback onBack;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Center(
      child: Padding(
        padding: AppSpacing.insetXxl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.searchX,
              size: AppSpacing.iconXxl,
              color: colorScheme.onSurfaceVariant,
            ),
            AppSpacing.gapVLg,
            Text(
              message ?? "Exercice introuvable",
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVLg,
            OutlinedButton(onPressed: onBack, child: const Text("Retour")),
          ],
        ),
      ),
    );
  }
}
