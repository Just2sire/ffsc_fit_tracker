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

class ProgramListPage extends ConsumerWidget {
  const ProgramListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(programsStreamProvider);

    return AppScaffold(
      body: Column(
        children: [
          const AppTopbar(title: "Programmes"),
          AppSpacing.gapVSm,
          Expanded(
            child: programsAsync.when(
              data: (programs) {
                if (programs.isEmpty) return const _EmptyState();
                return ListView.separated(
                  padding: const EdgeInsets.only(
                    bottom: AppSpacing.bottomScrollablePadding,
                  ),
                  itemCount: programs.length,
                  separatorBuilder: (_, _) => AppSpacing.gapVMd,
                  itemBuilder: (context, index) {
                    final program = programs[index];
                    return ProgramCard(
                      program: program,
                      onTap: () => context.pushToProgramDetail(program.id),
                      onArchive: () async {
                        final confirmed = await context.showConfirmDialog(
                          title: "Archiver le programme",
                          content:
                              "\"${program.name}\" sera masqué. "
                              "Tes séances passées ne seront pas supprimées.",
                          confirmLabel: "Archiver",
                          destructive: true,
                        );
                        if (confirmed == true) {
                          await ref
                              .read(programMutationsProvider.notifier)
                              .archiveProgram(program.id);
                          if (context.mounted) {
                            context.showSuccess("Programme archivé.");
                          }
                        }
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Erreur : $e")),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.pushToProgramNew(),
              label: const Text("Ajouter un programme"),
              icon: const Icon(LucideIcons.plus, size: AppSpacing.iconLg),
              iconAlignment: .start,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Center(
      child: Padding(
        padding: AppSpacing.insetXxl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.lg,
          children: [
            Icon(
              LucideIcons.clipboardList,
              size: AppSpacing.iconXxl,
              color: colorScheme.onSurfaceVariant,
            ),
            Column(
              spacing: AppSpacing.sm,
              children: [
                Text(
                  "Aucun programme",
                  style: textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Crée ton premier programme\npour commencer à t'entraîner.",
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
