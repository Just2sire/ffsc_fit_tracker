import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/extensions/navigation_extensions.dart";
import "../../../../core/extensions/string_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart" show AppScaffold, AppTopbar;
import "../../../programs/presentation/providers/program_provider.dart";
import "../../../programs/presentation/widgets/index.dart" show ProgramCard;

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(programsStreamProvider);
    final totalDaysAsync = ref.watch(totalDaysCountProvider);

    final programCount = programsAsync.asData?.value.length;
    final totalDays = totalDaysAsync.asData?.value;

    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return AppScaffold(
      scrollable: true,
      floatingActionButton: FloatingActionButton.extended(
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedLg),
        tooltip: "Nouveau programme",
        onPressed: () => context.pushToProgramNew(),
        label: Text(
          "Nouveau programme",
          style: context.textTheme.bodyLarge!.copyWith(
            color: context.colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: const Icon(LucideIcons.plus, size: AppSpacing.iconLg),
      ),
      body: Column(
        spacing: AppSpacing.sm,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTopbar(
            title: "Bienvenue, moussaillon",
            subtitle: "Prêt à t'entraîner ?",
            subTitleTextStyle: context.textTheme.bodySmall,
            showLeading: false,
            titleSubtitleSpacing: 0,
          ),
          Container(
            padding: AppSpacing.insetLg,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: AppSpacing.roundedXl,
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      icon: LucideIcons.clipboardList,
                      value: programCount != null ? "$programCount" : "—",
                      label: (programCount ?? 0) <= 1
                          ? "programme actif"
                          : "programmes actifs",
                    ),
                  ),
                  VerticalDivider(
                    color: colorScheme.outlineVariant,
                    thickness: 1,
                    width: AppSpacing.xl,
                  ),
                  Expanded(
                    child: _StatItem(
                      icon: LucideIcons.calendarDays,
                      value: totalDays != null ? "$totalDays" : "—",
                      label: (totalDays ?? 0) <= 1
                          ? "jour configuré"
                          : "jours configurés",
                    ),
                  ),
                ],
              ),
            ),
          ),

          Row(
            children: [
              Text("Programmes récents", style: textTheme.titleSmall),
              const Spacer(),
              TextButton(
                onPressed: () => context.pushToPrograms(),
                child: const Text("Voir tout"),
              ),
            ],
          ),

          programsAsync.when(
            data: (programs) {
              if (programs.isEmpty) {
                return const _EmptyPrograms();
              }
              final recent = programs.take(3).toList();
              return Column(
                children: [
                  for (final program in recent)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ProgramCard(
                        program: program,
                        onTap: () => context.pushToProgramDetail(program.id),
                      ),
                    ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Erreur : $e")),
          ),

        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.xs,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              value,
              style: textTheme.headlineLarge?.copyWith(
                color: colorScheme.accentForeground,
                fontWeight: FontWeight.w700,
              ),
            ),
            Icon(
              icon,
              size: AppSpacing.iconLg,
              color: colorScheme.accentForeground,
            ),
          ],
        ),
        Text(
          label.capitalize,
          style: textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─── Empty state ─────────────────────────────────────────────────────────────

class _EmptyPrograms extends StatelessWidget {
  const _EmptyPrograms();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Padding(
      padding: AppSpacing.screenPaddingH.copyWith(top: AppSpacing.md),
      child: Column(
        spacing: AppSpacing.md,
        children: [
          Icon(
            LucideIcons.clipboardList,
            size: AppSpacing.iconXxl,
            color: colorScheme.onSurfaceVariant,
          ),
          Text(
            "Aucun programme pour l'instant.\n"
            "Crée ton premier programme pour commencer.",
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          OutlinedButton(
            onPressed: () => context.pushToProgramNew(),
            child: const Text("Créer un programme"),
          ),
        ],
      ),
    );
  }
}
