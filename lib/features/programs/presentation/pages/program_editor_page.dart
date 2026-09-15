import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:uuid/uuid.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/extensions/string_extensions.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/domain/enums/training_goal.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar, AppTextFormField;
import "../../../exercise_library/domain/entities/exercise.dart";
import "../../../exercise_library/presentation/providers/exercise_provider.dart";
import "../../domain/entities/program_exercise.dart";
import "../../domain/entities/workout_day.dart";
import "../../domain/entities/workout_program.dart";
import "../providers/program_provider.dart";
import "../widgets/program_card.dart";

const _uuid = Uuid();

// ─── Draft state ─────────────────────────────────────────────────────────────

class _ExerciseDraft {
  _ExerciseDraft({
    required this.exerciseId,
    required this.exerciseName,
    this.existingId,
    this.targetSets = 3,
    this.targetRepsMin = 8,
    this.targetRepsMax = 12,
    this.restTimeSeconds = 90,
  }) : id = _uuid.v4();

  final String id;
  final String? existingId;
  final String exerciseId;
  final String exerciseName;
  int targetSets;
  int targetRepsMin;
  int targetRepsMax;
  int restTimeSeconds;

  String get resolvedId => existingId ?? id;
}

class _DayDraft {
  _DayDraft({
    required this.nameController,
    this.existingId,
    List<_ExerciseDraft>? exercises,
  }) : id = _uuid.v4(),
       exercises = exercises ?? [],
       deletedExerciseLibraryIds = [];

  final String id;
  final String? existingId;
  final TextEditingController nameController;
  final List<_ExerciseDraft> exercises;
  final List<String> deletedExerciseLibraryIds;

  String get resolvedId => existingId ?? id;

  void dispose() => nameController.dispose();
}

// ─── Page ────────────────────────────────────────────────────────────────────

class ProgramEditorPage extends ConsumerStatefulWidget {
  const ProgramEditorPage({super.key, this.programId});

  /// `null` → mode création, non-null → mode édition.
  final String? programId;

  @override
  ConsumerState<ProgramEditorPage> createState() => _ProgramEditorPageState();
}

class _ProgramEditorPageState extends ConsumerState<ProgramEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  TrainingGoal _selectedGoal = TrainingGoal.hypertrophy;
  List<_DayDraft> _days = [];
  final List<String> _deletedDayIds = [];

  bool _isLoading = false;
  bool _isSaving = false;

  bool get _isEditMode => widget.programId != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!_isEditMode) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(programRepositoryProvider);
      final exRepo = ref.read(exerciseRepositoryProvider);

      final program = await repo.getProgramById(widget.programId!);
      if (program == null) {
        if (mounted) context.pop();
        return;
      }

      final allExercises = await exRepo.getAllExercises();
      final nameMap = {for (final e in allExercises) e.id: e.name};

      final days = await repo.watchProgramDays(widget.programId!).first;
      final dayDrafts = <_DayDraft>[];

      for (final day in days) {
        final exercises = await repo.getExercisesForDay(day.id);
        final exDrafts = exercises
            .map(
              (e) => _ExerciseDraft(
                existingId: e.id,
                exerciseId: e.exerciseId,
                exerciseName: nameMap[e.exerciseId] ?? "Exercice inconnu",
                targetSets: e.targetSets,
                targetRepsMin: e.targetRepsMin,
                targetRepsMax: e.targetRepsMax,
                restTimeSeconds: e.restTimeSeconds,
              ),
            )
            .toList();

        dayDrafts.add(
          _DayDraft(
            existingId: day.id,
            nameController: TextEditingController(text: day.name),
            exercises: exDrafts,
          ),
        );
      }

      if (mounted) {
        setState(() {
          _nameController.text = program.name;
          _selectedGoal = program.goal;
          _days = dayDrafts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        context
          ..showError("Erreur lors du chargement : $e")
          ..pop();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final day in _days) {
      day.dispose();
    }
    super.dispose();
  }

  // ─── Mutations ─────────────────────────────────────────────────────────────

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_days.isEmpty) {
      context.showError("Ajoute au moins un jour.");
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(programRepositoryProvider);
      final programId = widget.programId ?? _uuid.v4();

      await repo.saveProgram(
        WorkoutProgram(
          id: programId,
          name: _nameController.text.trim(),
          goal: _selectedGoal,
        ),
      );

      for (final deletedId in _deletedDayIds) {
        await repo.deleteDay(deletedId);
      }

      for (var i = 0; i < _days.length; i++) {
        final draft = _days[i];
        final dayId = draft.resolvedId;

        await repo.saveDay(
          WorkoutDay(
            id: dayId,
            programId: programId,
            name: draft.nameController.text.trim(),
            dayOrder: i,
          ),
        );

        for (final libId in draft.deletedExerciseLibraryIds) {
          await repo.removeExerciseFromDay(dayId, libId);
        }

        for (var j = 0; j < draft.exercises.length; j++) {
          final ex = draft.exercises[j];
          final programExercise = ProgramExercise(
            id: ex.resolvedId,
            workoutDayId: dayId,
            exerciseId: ex.exerciseId,
            sortOrder: j,
            targetSets: ex.targetSets,
            targetRepsMin: ex.targetRepsMin,
            targetRepsMax: ex.targetRepsMax,
            restTimeSeconds: ex.restTimeSeconds,
          );

          if (ex.existingId != null) {
            await repo.updateProgramExercise(programExercise);
          } else {
            await repo.addExerciseToDay(programExercise);
          }
        }
      }

      if (mounted) {
        context
          ..showSuccess(
            _isEditMode ? "Programme mis à jour." : "Programme créé.",
          )
          ..pop();
      }
    } catch (e) {
      if (mounted) {
        context.showError("Erreur lors de la sauvegarde : $e");
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ─── Day CRUD ──────────────────────────────────────────────────────────────

  void _addDay() {
    setState(() {
      _days.add(
        _DayDraft(
          nameController: TextEditingController(
            text: "Jour ${_days.length + 1}",
          ),
        ),
      );
    });
  }

  void _removeDay(int index) {
    setState(() {
      final draft = _days.removeAt(index);
      if (draft.existingId != null) _deletedDayIds.add(draft.existingId!);
      draft.dispose();
    });
  }

  Future<void> _renameDay(int index) async {
    final ctrl = TextEditingController(text: _days[index].nameController.text);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => _RenameDayDialog(controller: ctrl),
    );
    if (result != null && result.trim().isNotEmpty) {
      setState(() => _days[index].nameController.text = result.trim());
    }
  }

  // ─── Exercise CRUD ─────────────────────────────────────────────────────────

  Future<void> _addExerciseToDay(int dayIndex) async {
    final draft = await showModalBottomSheet<_ExerciseDraft>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ExercisePickerSheet(
        existingExerciseIds: _days[dayIndex].exercises
            .map((e) => e.exerciseId)
            .toSet(),
      ),
    );
    if (draft != null) {
      setState(() => _days[dayIndex].exercises.add(draft));
    }
  }

  void _removeExerciseFromDay(int dayIndex, int exerciseIndex) {
    setState(() {
      final ex = _days[dayIndex].exercises.removeAt(exerciseIndex);
      if (ex.existingId != null) {
        _days[dayIndex].deletedExerciseLibraryIds.add(ex.exerciseId);
      }
    });
  }

  void _reorderExercises(int dayIndex, int oldIndex, int newIndex) {
    setState(() {
      final item = _days[dayIndex].exercises.removeAt(oldIndex);
      _days[dayIndex].exercises.insert(newIndex, item);
    });
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    if (_isLoading) {
      return const AppScaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return AppScaffold(
      scrollable: true,
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xl,
          children: [
            AppTopbar(
              title: _isEditMode
                  ? "Modifier le programme"
                  : "Nouveau programme",
              actions: [
                IconButton(
                  onPressed: _isSaving ? null : _save,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(LucideIcons.save),
                  tooltip: "Sauvegarder",
                ),
                // TextButton(
                //   onPressed: _isSaving ? null : _save,
                //   child: _isSaving
                //       ? const SizedBox(
                //           width: 16,
                //           height: 16,
                //           child: CircularProgressIndicator(strokeWidth: 2),
                //         )
                //       : const Text("Sauvegarder"),
                // ),
              ],
            ),
            Column(
              crossAxisAlignment: .start,
              spacing: AppSpacing.sm,
              children: [
                Text("Nom du programme", style: textTheme.labelLarge),
                AppTextFormField(
                  controller: _nameController,
                  hintText: "Ex : PPL — Push Pull Legs",
                  textCapitalization: TextCapitalization.words,
                  isRequired: true,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                Text("Objectif", style: textTheme.labelLarge),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: TrainingGoal.values.map((goal) {
                    final selected = _selectedGoal == goal;
                    return FilterChip(
                      label: Text(goal.label),
                      selected: selected,
                      avatar: selected
                          ? null
                          : Icon(
                              ProgramCard.goalIcon(goal),
                              size: AppSpacing.iconSm,
                              color: ProgramCard.goalColor(goal),
                            ),
                      selectedColor: ProgramCard.goalBgColor(goal),
                      checkmarkColor: ProgramCard.goalColor(goal),
                      labelStyle: TextStyle(
                        color: selected
                            ? ProgramCard.goalColor(goal)
                            : colorScheme.onSurfaceVariant,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      onSelected: (_) => setState(() => _selectedGoal = goal),
                    );
                  }).toList(),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.md,
              children: [
                Row(
                  children: [
                    Text("Jours d'entraînement", style: textTheme.labelLarge),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _addDay,
                      icon: const Icon(LucideIcons.plus, size: 14),
                      label: const Text("Ajouter"),
                    ),
                  ],
                ),
                if (_days.isEmpty)
                  Container(
                    padding: AppSpacing.insetLg,
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outlineVariant),
                      borderRadius: AppSpacing.roundedLg,
                    ),
                    child: Center(
                      child: Text(
                        "Aucun jour. Appuie sur \"Ajouter\" pour en créer un.",
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ...List.generate(_days.length, (index) {
                    return _DaySection(
                      key: ValueKey(_days[index].id),
                      draft: _days[index],
                      index: index,
                      onRename: () => _renameDay(index),
                      onRemove: () => _removeDay(index),
                      onAddExercise: () => _addExerciseToDay(index),
                      onRemoveExercise: (exIndex) =>
                          _removeExerciseFromDay(index, exIndex),
                      onReorder: (oldIndex, newIndex) =>
                          _reorderExercises(index, oldIndex, newIndex),
                    );
                  }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({
    super.key,
    required this.draft,
    required this.index,
    required this.onRename,
    required this.onRemove,
    required this.onAddExercise,
    required this.onRemoveExercise,
    required this.onReorder,
  });

  final _DayDraft draft;
  final int index;
  final VoidCallback onRename;
  final VoidCallback onRemove;
  final VoidCallback onAddExercise;
  final void Function(int) onRemoveExercise;
  final void Function(int, int) onReorder;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final dayName = draft.nameController.text;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: AppSpacing.roundedXl,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header du jour
          Padding(
            padding: AppSpacing.listItemPadding,
            child: Row(
              children: [
                Container(
                  width: AppSpacing.avatarSm,
                  height: AppSpacing.avatarSm,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "${index + 1}",
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AppSpacing.gapHSm,
                Expanded(
                  child: Text(
                    dayName,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  borderRadius: AppSpacing.roundedSm,
                  onTap: onRename,
                  child: Padding(
                    padding: AppSpacing.insetXs,
                    child: Icon(
                      LucideIcons.pencil,
                      size: AppSpacing.iconSm,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                AppSpacing.gapHSm,
                InkWell(
                  borderRadius: AppSpacing.roundedSm,
                  onTap: onRemove,
                  child: Padding(
                    padding: AppSpacing.insetXs,
                    child: Icon(
                      LucideIcons.trash2,
                      size: AppSpacing.iconSm,
                      color: colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (draft.exercises.isNotEmpty) ...[
            Divider(height: 1, color: colorScheme.outlineVariant),
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: draft.exercises.length,
              onReorderItem: onReorder,
              proxyDecorator: (child, index, animation) => Material(
                elevation: AppSpacing.elevationMd,
                borderRadius: AppSpacing.roundedMd,
                color: colorScheme.surfaceContainerHighest,
                child: child,
              ),
              itemBuilder: (context, i) {
                final ex = draft.exercises[i];
                return _ExerciseDraftTile(
                  key: ValueKey(ex.id),
                  draft: ex,
                  onDelete: () => onRemoveExercise(i),
                );
              },
            ),
          ],

          // Bouton "Ajouter un exercice"
          InkWell(
            onTap: onAddExercise,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppSpacing.radiusXl),
              bottomRight: Radius.circular(AppSpacing.radiusXl),
            ),
            child: Padding(
              padding: AppSpacing.listItemPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: AppSpacing.sm,
                children: [
                  Icon(
                    LucideIcons.plus,
                    size: AppSpacing.iconSm,
                    color: colorScheme.accentForeground,
                  ),
                  Text(
                    "Ajouter un exercice",
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.accentForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Exercise draft tile (dans l'éditeur) ────────────────────────────────────

class _ExerciseDraftTile extends StatelessWidget {
  const _ExerciseDraftTile({
    super.key,
    required this.draft,
    required this.onDelete,
  });

  final _ExerciseDraft draft;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final prescription =
        "${draft.targetSets} séries · "
        "${draft.targetRepsMin}–${draft.targetRepsMax} reps · "
        "${draft.restTimeSeconds}s repos";

    return Padding(
      padding: AppSpacing.listItemPaddingSm,
      child: Row(
        children: [
          Icon(
            LucideIcons.gripVertical,
            size: AppSpacing.iconMd,
            color: colorScheme.onSurfaceVariant,
          ),
          AppSpacing.gapHSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Text(
                  draft.exerciseName.capitalizeWords,
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
          IconButton(
            onPressed: onDelete,
            visualDensity: VisualDensity.compact,
            icon: Icon(
              LucideIcons.x,
              size: AppSpacing.iconSm,
              color: colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Rename day dialog ───────────────────────────────────────────────────────

class _RenameDayDialog extends StatelessWidget {
  const _RenameDayDialog({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Renommer le jour"),
      content: TextField(
        controller: controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(hintText: "Ex : Push, Pull, Legs…"),
        onSubmitted: (value) => Navigator.pop(context, value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: const Text("Renommer"),
        ),
      ],
    );
  }
}

// ─── Exercise picker bottom sheet ────────────────────────────────────────────

class _ExercisePickerSheet extends ConsumerStatefulWidget {
  const _ExercisePickerSheet({required this.existingExerciseIds});

  final Set<String> existingExerciseIds;

  @override
  ConsumerState<_ExercisePickerSheet> createState() =>
      _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends ConsumerState<_ExercisePickerSheet> {
  final _searchController = TextEditingController();
  String _query = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final exercisesAsync = ref.watch(exercisesListProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppSpacing.roundedTopXl,
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: AppSpacing.roundedFull,
                  ),
                ),
              ),
              // Title + search
              Padding(
                padding: AppSpacing.screenPaddingH.copyWith(
                  bottom: AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.sm,
                  children: [
                    Text(
                      "Choisir un exercice",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Rechercher…",
                        prefixIcon: const Icon(LucideIcons.search, size: 18),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: AppSpacing.roundedLg,
                          borderSide: BorderSide(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                      onChanged: (v) =>
                          setState(() => _query = v.toLowerCase()),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: colorScheme.outlineVariant),
              Expanded(
                child: exercisesAsync.when(
                  data: (exercises) {
                    final filtered = exercises.where((e) {
                      if (widget.existingExerciseIds.contains(e.id)) {
                        return false;
                      }
                      return _query.isEmpty ||
                          e.name.toLowerCase().contains(_query);
                    }).toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          "Aucun exercice trouvé",
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final exercise = filtered[i];
                        return _ExercisePickerItem(
                          exercise: exercise,
                          onSelect: () => _onExerciseSelected(exercise),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text("Erreur : $e")),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onExerciseSelected(Exercise exercise) async {
    final prescription = await showDialog<_PrescriptionResult>(
      context: context,
      builder: (_) => _PrescriptionDialog(exerciseName: exercise.name),
    );
    if (prescription != null && mounted) {
      Navigator.of(context).pop(
        _ExerciseDraft(
          exerciseId: exercise.id,
          exerciseName: exercise.name,
          targetSets: prescription.sets,
          targetRepsMin: prescription.repsMin,
          targetRepsMax: prescription.repsMax,
          restTimeSeconds: prescription.restSeconds,
        ),
      );
    }
  }
}

class _ExercisePickerItem extends StatelessWidget {
  const _ExercisePickerItem({required this.exercise, required this.onSelect});

  final Exercise exercise;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return InkWell(
      onTap: onSelect,
      child: Padding(
        padding: AppSpacing.listItemPadding,
        child: Row(
          spacing: AppSpacing.md,
          children: [
            Container(
              width: AppSpacing.avatarSm,
              height: AppSpacing.avatarSm,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: AppSpacing.roundedSm,
              ),
              child: Icon(
                LucideIcons.dumbbell,
                size: AppSpacing.iconSm,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xs,
                children: [
                  Text(
                    exercise.name.capitalizeWords,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    exercise.primaryMuscle.label,
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.plus,
              size: AppSpacing.iconSm,
              color: colorScheme.accentForeground,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Prescription dialog ─────────────────────────────────────────────────────

class _PrescriptionResult {
  const _PrescriptionResult({
    required this.sets,
    required this.repsMin,
    required this.repsMax,
    required this.restSeconds,
  });

  final int sets;
  final int repsMin;
  final int repsMax;
  final int restSeconds;
}

class _PrescriptionDialog extends StatefulWidget {
  const _PrescriptionDialog({required this.exerciseName});

  final String exerciseName;

  @override
  State<_PrescriptionDialog> createState() => _PrescriptionDialogState();
}

class _PrescriptionDialogState extends State<_PrescriptionDialog> {
  final _setsCtrl = TextEditingController(text: "3");
  final _repsMinCtrl = TextEditingController(text: "8");
  final _repsMaxCtrl = TextEditingController(text: "12");
  final _restCtrl = TextEditingController(text: "90");
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _setsCtrl.dispose();
    _repsMinCtrl.dispose();
    _repsMaxCtrl.dispose();
    _restCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final sets = int.parse(_setsCtrl.text);
    final repsMin = int.parse(_repsMinCtrl.text);
    final repsMax = int.parse(_repsMaxCtrl.text);
    final rest = int.parse(_restCtrl.text);
    if (repsMin > repsMax) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reps min doit être ≤ reps max."),
          backgroundColor: AppColors.semanticError,
        ),
      );
      return;
    }
    Navigator.pop(
      context,
      _PrescriptionResult(
        sets: sets,
        repsMin: repsMin,
        repsMax: repsMax,
        restSeconds: rest,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.exerciseName.capitalizeWords,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.sm,
          children: [
            _IntField(controller: _setsCtrl, label: "Séries", min: 1, max: 20),
            Row(
              spacing: AppSpacing.sm,
              children: [
                Expanded(
                  child: _IntField(
                    controller: _repsMinCtrl,
                    label: "Reps min",
                    min: 1,
                    max: 100,
                  ),
                ),
                Expanded(
                  child: _IntField(
                    controller: _repsMaxCtrl,
                    label: "Reps max",
                    min: 1,
                    max: 100,
                  ),
                ),
              ],
            ),
            _IntField(
              controller: _restCtrl,
              label: "Repos (secondes)",
              min: 0,
              max: 600,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        FilledButton(onPressed: _submit, child: const Text("Ajouter")),
      ],
    );
  }
}

class _IntField extends StatelessWidget {
  const _IntField({
    required this.controller,
    required this.label,
    required this.min,
    required this.max,
  });

  final TextEditingController controller;
  final String label;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: .next,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      labelText: label,
      // decoration: InputDecoration(
      //   labelText: label,
      //   isDense: true,
      //   border: const OutlineInputBorder(),
      // ),
      validatorFunction: (v) {
        final n = int.tryParse(v ?? "");
        if (n == null) return "Entier requis";
        if (n < min || n > max) return "$min–$max";
        return null;
      },
    );
  }
}
