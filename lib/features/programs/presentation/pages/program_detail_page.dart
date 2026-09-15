import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/extensions/navigation_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar;
import "../providers/program_provider.dart";
import "../widgets/index.dart";

class ProgramDetailPage extends ConsumerWidget {
  const ProgramDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programAsync = ref.watch(programByIdProvider(id));
    final daysAsync = ref.watch(programDaysStreamProvider(id));

    return AppScaffold(
      body: programAsync.when(
        data: (program) {
          if (program == null) {
            return _NotFound(onBack: () => context.pop());
          }

          final colorScheme = context.colorScheme;
          final textTheme = context.textTheme;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTopbar(
                title: program.name,
                actions: [
                  IconButton(
                    onPressed: () => context.pushToProgramEdit(id),
                    icon: Icon(
                      LucideIcons.pencil,
                      size: AppSpacing.iconMd,
                      color: colorScheme.onSurface,
                    ),
                    tooltip: "Modifier le programme",
                  ),
                ],
              ),
              GoalChip(goal: program.goal),
              AppSpacing.gapVLg,
              Expanded(
                child: daysAsync.when(
                  data: (days) {
                    if (days.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: AppSpacing.md,
                          children: [
                            Icon(
                              LucideIcons.calendarOff,
                              size: AppSpacing.iconXxl,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            Text(
                              "Aucun jour dans ce programme.\n"
                              "Modifie le programme pour en ajouter.",
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      // padding: AppSpacing.screenPaddingH.copyWith(
                      //   bottom: AppSpacing.bottomScrollablePadding,
                      //   top: AppSpacing.xs,
                      // ),
                      itemCount: days.length,
                      separatorBuilder: (_, _) => AppSpacing.gapVSm,
                      itemBuilder: (_, index) {
                        final day = days[index];
                        return WorkoutDayTile(
                          dayId: day.id,
                          dayOrder: day.dayOrder,
                          dayName: day.name,
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text("Erreur : $e")),
                ),
              ),
              // ── Bouton démarrer ──────────────────────────────
              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeightLg,
                child: FilledButton.icon(
                  onPressed: null, // sera câblé en M-06
                  icon: const Icon(LucideIcons.play),
                  label: const Text("Démarrer la séance"),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _NotFound(
          onBack: () => context.pop(),
          message: "Erreur : $e",
        ),
      ),
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
          spacing: AppSpacing.lg,
          children: [
            Icon(
              LucideIcons.searchX,
              size: AppSpacing.iconXxl,
              color: colorScheme.onSurfaceVariant,
            ),
            Text(
              message ?? "Programme introuvable",
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            OutlinedButton(onPressed: onBack, child: const Text("Retour")),
          ],
        ),
      ),
    );
  }
}
