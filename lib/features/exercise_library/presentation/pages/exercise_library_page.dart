import "package:fit_tracker/core/extensions/index.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar, AppTextFormField;
import "../providers/exercise_provider.dart";
import "../widgets/index.dart";

class ExerciseLibraryPage extends ConsumerWidget {
  const ExerciseLibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final exercisesAsync = ref.watch(filteredExercisesProvider);
    final activeFilterCount =
        ref.watch(muscleFilterProvider).length +
        ref.watch(equipmentFilterProvider).length;

    return AppScaffold(
      body: Column(
        spacing: AppSpacing.md,
        children: [
          const AppTopbar(title: "Exercices", showLeading: false),
          Row(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: AppTextFormField(
                  hintText: "Rechercher un exercice…",
                  onChanged: (value) => ref
                      .read(exerciseSearchQueryProvider.notifier)
                      .set(value ?? ""),
                ),
              ),
              Badge(
                label: Text("$activeFilterCount"),
                isLabelVisible: activeFilterCount > 0,
                child: IconButton(
                  style: IconButton.styleFrom(
                    padding: AppSpacing.insetLg,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppSpacing.roundedLg,
                    ),
                    backgroundColor: colorScheme.primary,
                  ),
                  onPressed: () => showExerciseFilterSheet(context),
                  icon: Icon(LucideIcons.filter, color: colorScheme.surface),
                ),
              ),
            ],
          ),
          Expanded(
            child: exercisesAsync.when(
              data: (exercises) {
                if (exercises.isEmpty) {
                  return const Center(child: Text("Aucun exercice trouvé"));
                }
                return GridView.builder(
                  padding: .zero,
                  itemCount: exercises.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: AppSpacing.sm,
                    mainAxisSpacing: AppSpacing.sm,
                  ),
                  itemBuilder: (context, index) {
                    final exo = exercises[index];
                    return ExerciseCard(
                      exercise: exo,
                      onTap: () => context.pushToExerciseDetail(exo.id),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text("Erreur: $error")),
            ),
          ),
        ],
      ),
    );
  }
}
