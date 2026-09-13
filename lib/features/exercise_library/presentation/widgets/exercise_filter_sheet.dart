import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/extensions/string_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/domain/enums/index.dart" show Equipment, MuscleGroup;
import "../../../../shared/presentation/widgets/app_text_form_field.dart";
import "../providers/exercise_provider.dart";

/// Ouvre le bottom sheet de filtres (muscles + équipement, multi-sélection).
Future<void> showExerciseFilterSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const ExerciseFilterSheet(),
  );
}

class ExerciseFilterSheet extends ConsumerStatefulWidget {
  const ExerciseFilterSheet({super.key});

  @override
  ConsumerState<ExerciseFilterSheet> createState() =>
      _ExerciseFilterSheetState();
}

class _ExerciseFilterSheetState extends ConsumerState<ExerciseFilterSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Sélection locale — appliquée aux providers seulement au clic sur
  // "Appliquer", pour ne pas re-filtrer la grille à chaque coche.
  late Set<MuscleGroup> _muscles;
  late Set<Equipment> _equipments;

  String _muscleQuery = "";
  String _equipmentQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _muscles = {...ref.read(muscleFilterProvider)};
    _equipments = {...ref.read(equipmentFilterProvider)};
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get _totalSelected => _muscles.length + _equipments.length;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppSpacing.roundedTopXl,
          ),
          child: Column(
            children: [
              AppSpacing.gapVSm,
              Container(
                width: AppSpacing.huge,
                height: AppSpacing.xs,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: AppSpacing.roundedFull,
                ),
              ),
              Row(
                children: [
                  Text("Filtres", style: textTheme.titleMedium),
                  const Spacer(),
                  if (_totalSelected > 0)
                    TextButton(
                      onPressed: () => setState(() {
                        _muscles.clear();
                        _equipments.clear();
                      }),
                      child: const Text("Réinitialiser"),
                    ),
                ],
              ),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: "Muscles (${_muscles.length})"),
                  Tab(text: "Équipement (${_equipments.length})"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _FilterList<MuscleGroup>(
                      scrollController: scrollController,
                      allValues: MuscleGroup.values,
                      labelOf: (m) => m.label,
                      selected: _muscles,
                      query: _muscleQuery,
                      onQueryChanged: (v) => setState(() => _muscleQuery = v),
                      onToggle: (m) => setState(() {
                        _muscles.contains(m)
                            ? _muscles.remove(m)
                            : _muscles.add(m);
                      }),
                    ),
                    _FilterList<Equipment>(
                      scrollController: scrollController,
                      allValues: Equipment.values,
                      labelOf: (e) => e.label,
                      selected: _equipments,
                      query: _equipmentQuery,
                      onQueryChanged: (v) =>
                          setState(() => _equipmentQuery = v),
                      onToggle: (e) => setState(() {
                        _equipments.contains(e)
                            ? _equipments.remove(e)
                            : _equipments.add(e);
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(muscleFilterProvider.notifier).set(_muscles);
                    ref.read(equipmentFilterProvider.notifier).set(_equipments);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    _totalSelected == 0
                        ? "Appliquer"
                        : "Appliquer ($_totalSelected)",
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterList<T> extends StatelessWidget {
  const _FilterList({
    required this.scrollController,
    required this.allValues,
    required this.labelOf,
    required this.selected,
    required this.query,
    required this.onQueryChanged,
    required this.onToggle,
  });

  final ScrollController scrollController;
  final List<T> allValues;
  final String Function(T) labelOf;
  final Set<T> selected;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<T> onToggle;

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = query.trim().toLowerCase();
    final filtered = normalizedQuery.isEmpty
        ? allValues
        : allValues
              .where((v) => labelOf(v).toLowerCase().contains(normalizedQuery))
              .toList();

    return Column(
      children: [
        Padding(
          padding: AppSpacing.screenPaddingH.copyWith(top: AppSpacing.sm),
          child: AppTextFormField(
            hintText: "Rechercher…",
            onChanged: (value) => onQueryChanged(value ?? ""),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text("Aucun résultat"))
              : ListView.builder(
                  controller: scrollController,
                  padding: AppSpacing.insetVSm,
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final value = filtered[index];
                    final isSelected = selected.contains(value);
                    return CheckboxListTile(
                      value: isSelected,
                      onChanged: (_) => onToggle(value),
                      title: Text(labelOf(value).capitalize),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
