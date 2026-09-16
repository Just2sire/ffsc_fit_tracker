import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/extensions/duration_extensions.dart";
import "../../../../core/extensions/string_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/domain/enums/index.dart";
import "../../../../shared/presentation/providers/notification_providers.dart";
import "../../../../shared/presentation/widgets/index.dart" show AppScaffold;
import "../../domain/entities/exercise_set.dart";
import "../../domain/entities/progression_suggestion.dart";
import "../../domain/entities/workout_session.dart";
import "../providers/active_exercise_providers.dart";
import "../providers/active_session_notifier.dart";
import "../providers/rest_timer_notifier.dart";
import "../widgets/rest_timer_overlay.dart";

class ActiveSessionPage extends ConsumerStatefulWidget {
  const ActiveSessionPage({super.key, this.workoutDayId});

  /// Renseigné quand on arrive depuis "Démarrer la séance" (M-05) — la page
  /// démarre alors elle-même la séance. `null` = on arrive en reprise d'une
  /// séance déjà active (ex: bannière de récupération, M-12).
  final String? workoutDayId;

  @override
  ConsumerState createState() => _ActiveSessionPageState();
}

class _ActiveSessionPageState extends ConsumerState<ActiveSessionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onFirstFrame());
  }

  Future<void> _onFirstFrame() async {
    await ref.read(notificationServiceProvider).requestPermission();
    final workoutDayId = widget.workoutDayId;
    if (workoutDayId != null) {
      await _startIfNeeded(workoutDayId);
    }
  }

  Future<void> _startIfNeeded(String workoutDayId) async {
    final alreadyActive = ref.read(activeSessionProvider).value != null;
    if (alreadyActive) return;
    await ref.read(activeSessionProvider.notifier).start(workoutDayId);
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(activeSessionProvider);

    return AppScaffold(
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Erreur : $error")),
        data: (session) {
          if (session == null) {
            return const Center(child: Text("Aucune séance en cours"));
          }
          return _SessionScaffold(session: session);
        },
      ),
    );
  }
}

class _SessionScaffold extends StatelessWidget {
  const _SessionScaffold({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TopBarSection(session: session),
                AppSpacing.gapVMd,
                const _ProgressSection(),
                AppSpacing.gapVMd,
              ],
            ),
            const Divider(thickness: 1, height: 1),
            const Expanded(child: _ExerciseWorkspaceSection()),
            const Divider(thickness: 1, height: 1),
            const _NavigatorSection(),
            _FinishButton(session: session),
            AppSpacing.gapVSm,
          ],
        ),
        const RestTimerOverlay(),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Top bar — nom du jour, timer, pause/play
// ═══════════════════════════════════════════════════════════════

class _TopBarSection extends ConsumerWidget {
  const _TopBarSection({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return Row(
      spacing: AppSpacing.sm,
      children: [
        const _PlayPauseButton(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.workoutDayNameSnapshot,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            ref
                .watch(sessionElapsedTimeProvider)
                .when(
                  data: (duration) => Text(
                    duration.toElapsedTimer(),
                    style: textTheme.titleLarge,
                  ),
                  loading: () => Text("00:00:00", style: textTheme.titleLarge),
                  error: (_, _) =>
                      Text("00:00:00", style: textTheme.titleLarge),
                ),
          ],
        ),
      ],
    );
  }
}

class _PlayPauseButton extends ConsumerStatefulWidget {
  const _PlayPauseButton();

  @override
  ConsumerState<_PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends ConsumerState<_PlayPauseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isToggling = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggle(SessionStatus status) async {
    setState(() => _isToggling = true);
    try {
      final notifier = ref.read(activeSessionProvider.notifier);
      if (status == SessionStatus.active) {
        await _controller.animateTo(1);
        await notifier.pause();
      } else if (status == SessionStatus.paused) {
        await _controller.animateTo(0);
        await notifier.resume();
      }
    } finally {
      if (mounted) setState(() => _isToggling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(activeSessionProvider).value?.status;
    if (!_controller.isAnimating && status != null) {
      _controller.value = status == SessionStatus.active ? 0 : 1;
    }
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: context.colorScheme.outline,
        fixedSize: const Size(AppSpacing.mega, AppSpacing.mega),
      ),
      onPressed: (status == null || _isToggling) ? null : () => _toggle(status),
      icon: AnimatedIcon(icon: AnimatedIcons.pause_play, progress: _controller),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Barre de progression — "Exercice X/Y"
// ═══════════════════════════════════════════════════════════════

class _ProgressSection extends ConsumerWidget {
  const _ProgressSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final exercisesAsync = ref.watch(sessionExercisesProvider);
    final currentIndex = ref.watch(currentExerciseIndexProvider);

    return exercisesAsync.when(
      data: (exercises) {
        final total = exercises.length;
        if (total == 0) return const SizedBox.shrink();
        final progress = (currentIndex + 1) / total;
        return Row(
          spacing: AppSpacing.sm,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: AppSpacing.roundedMd,
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: colorScheme.surfaceContainer,
                  valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                ),
              ),
            ),
            Text(
              "Exercice ${currentIndex + 1}/$total",
              style: textTheme.bodySmall,
            ),
          ],
        );
      },
      error: (_, _) => const Text("Erreur"),
      loading: () => const LinearProgressIndicator(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Corps — exercice courant, référence, suggestion, séries
// ═══════════════════════════════════════════════════════════════

class _ExerciseWorkspaceSection extends ConsumerWidget {
  const _ExerciseWorkspaceSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseAsync = ref.watch(currentSessionExerciseProvider);

    return exerciseAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text("Erreur : $error")),
      data: (exercise) {
        if (exercise == null) {
          return const Center(child: Text("Aucun exercice"));
        }
        return SingleChildScrollView(
          padding: AppSpacing.insetVMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise.exerciseNameSnapshot.capitalize,
                maxLines: 2,
                overflow: .ellipsis,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.gapVLg,
              const _ReferenceCard(),
              const _SuggestionBadge(),
              AppSpacing.gapVLg,
              const _SetList(),
            ],
          ),
        );
      },
    );
  }
}

class _ReferenceCard extends ConsumerWidget {
  const _ReferenceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(currentExerciseHistoryProvider);
    final history = historyAsync.value;
    if (history == null || history.isEmpty) return const SizedBox.shrink();

    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    const labels = ["Séance précédente", "Il y a 2 séances"];

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: AppSpacing.cardPaddingCompact,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: AppSpacing.roundedLg,
        ),
        child: Row(
          children: [
            for (var i = 0; i < history.length && i < 2; i++) ...[
              if (i > 0) AppSpacing.gapHLg,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      labels[i],
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    AppSpacing.gapVXs,
                    Text(
                      "${_formatWeight(_maxWeight(history[i]))} kg",
                      style: textTheme.titleSmall,
                    ),
                    Text(
                      "${history[i].map((s) => "${s.reps}").join(" · ")} reps",
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SuggestionBadge extends ConsumerWidget {
  const _SuggestionBadge();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestion = ref.watch(currentProgressionSuggestionProvider).value;
    final target = ref.watch(currentExerciseTargetProvider).value;
    if (suggestion == null || suggestion.trend == ProgressionTrend.noHistory) {
      return const SizedBox.shrink();
    }

    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final (icon, tint) = switch (suggestion.trend) {
      ProgressionTrend.increase => (
        LucideIcons.trendingUp,
        colorScheme.primary,
      ),
      ProgressionTrend.decrease => (
        LucideIcons.trendingDown,
        colorScheme.error,
      ),
      _ => (LucideIcons.minus, colorScheme.onSurfaceVariant),
    };

    final weightText = suggestion.suggestedWeight == null
        ? ""
        : "${_formatWeight(suggestion.suggestedWeight!)} kg";
    final rangeText = target == null
        ? ""
        : " · ${target.targetRepsMin}-${target.targetRepsMax}";

    return Container(
      padding: AppSpacing.chipPadding,
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: AppSpacing.roundedFull,
      ),
      child: Row(
        spacing: AppSpacing.sm,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSpacing.iconSm, color: tint),
          Flexible(
            child: Text(
              "$weightText$rangeText · ${suggestion.rationale}",
              style: textTheme.labelLarge?.copyWith(color: tint),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SetList extends ConsumerWidget {
  const _SetList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setsAsync = ref.watch(currentExerciseSetsProvider);

    return setsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text("Erreur : $error"),
      data: (sets) {
        return Column(
          spacing: AppSpacing.md,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final set in sets) _SetRow(set: set),
            AppSpacing.gapHXs,
            const _AddSetButton(),
          ],
        );
      },
    );
  }
}

class _SetRow extends ConsumerStatefulWidget {
  const _SetRow({required this.set});

  final ExerciseSet set;

  @override
  ConsumerState<_SetRow> createState() => _SetRowState();
}

class _SetRowState extends ConsumerState<_SetRow> {
  late final TextEditingController _weightController;
  late final TextEditingController _repsController;
  String? _error;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text: _formatWeight(widget.set.weight),
    );
    _repsController = TextEditingController(
      text: widget.set.reps == 0 ? "" : "${widget.set.reps}",
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  Future<void> _validate() async {
    final isBodyweight =
        ref.read(currentSessionExerciseProvider).value?.equipmentSnapshot ==
        Equipment.bodyweight;

    var weight = 0.0;
    if (!isBodyweight) {
      final parsed = double.tryParse(
        _weightController.text.trim().replaceAll(",", "."),
      );
      if (parsed == null || parsed < 0) {
        setState(() => _error = "Poids invalide");
        return;
      }
      weight = parsed;
    }

    final reps = int.tryParse(_repsController.text.trim());
    if (reps == null || reps <= 0) {
      setState(() => _error = "Répétitions invalides");
      return;
    }
    setState(() => _error = null);
    await HapticFeedback.mediumImpact();

    await ref
        .read(currentExerciseSetsProvider.notifier)
        .logSet(
          widget.set.copyWith(
            weight: weight,
            reps: reps,
            isCompleted: true,
            completedAt: DateTime.now(),
          ),
        );

    final exercise = ref.read(currentSessionExerciseProvider).value;
    final target = ref.read(currentExerciseTargetProvider).value;
    if (exercise != null && target != null && target.restTimeSeconds > 0) {
      await ref
          .read(restTimerProvider.notifier)
          .start(
            Duration(seconds: target.restTimeSeconds),
            exerciseName: exercise.exerciseNameSnapshot,
          );
    }
  }

  Future<void> _unvalidate() => ref
      .read(currentExerciseSetsProvider.notifier)
      .toggleCompleted(widget.set.id);

  Future<bool> _confirmDelete() async {
    final confirmed =
        await context.showConfirmDialog(
          title: "Supprimer la série",
          content: "Cette série sera définitivement supprimée.",
          confirmLabel: "Supprimer",
          destructive: true,
        ) ??
        false;
    if (!confirmed) return false;
    await ref
        .read(currentExerciseSetsProvider.notifier)
        .deleteSet(widget.set.id);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final set = widget.set;
    final isBodyweight =
        ref.watch(currentSessionExerciseProvider).value?.equipmentSnapshot ==
        Equipment.bodyweight;

    return Dismissible(
      key: ValueKey(set.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: AppSpacing.insetHLg,
        decoration: BoxDecoration(
          color: colorScheme.error.withValues(alpha: 0.12),
          borderRadius: AppSpacing.roundedMd,
        ),
        child: Icon(
          LucideIcons.trash2,
          color: colorScheme.error,
          size: AppSpacing.iconMd,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppSpacing.cardPaddingUltraCompact,
            decoration: BoxDecoration(
              color: set.isCompleted
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : colorScheme.surfaceContainer,
              borderRadius: AppSpacing.roundedMd,
              border: set.isCompleted
                  ? Border.all(color: colorScheme.primary)
                  : null,
            ),
            child: Row(
              spacing: AppSpacing.sm,
              children: [
                SizedBox(
                  width: AppSpacing.xxxl,
                  child: Text(
                    "S${set.setNumber}",
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: isBodyweight
                      ? Container(
                          height: AppSpacing.inputHeightSm,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainer,
                            borderRadius: AppSpacing.roundedSm,
                          ),
                          child: Text(
                            "Poids du corps",
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : TextField(
                          controller: _weightController,
                          enabled: !set.isCompleted,
                          textInputAction: .next,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            suffixText: "kg",
                          ),
                        ),
                ),
                Expanded(
                  child: TextField(
                    controller: _repsController,
                    enabled: !set.isCompleted,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: "reps",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: set.isCompleted ? _unvalidate : _validate,
                  style: IconButton.styleFrom(
                    backgroundColor: set.isCompleted
                        ? colorScheme.primary
                        : colorScheme.surfaceContainer,
                    shape: const CircleBorder(),
                  ),
                  icon: Icon(
                    LucideIcons.check,
                    size: 16,
                    color: set.isCompleted
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(
                _error!,
                style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddSetButton extends ConsumerWidget {
  const _AddSetButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      onPressed: () async {
        final sets = ref.read(currentExerciseSetsProvider).value ?? [];
        final suggestion = ref.read(currentProgressionSuggestionProvider).value;
        final target = ref.read(currentExerciseTargetProvider).value;
        final fallbackWeight = sets.isNotEmpty
            ? sets.last.weight
            : (suggestion?.suggestedWeight ?? 0);
        await ref
            .read(currentExerciseSetsProvider.notifier)
            .addSet(
              weight: fallbackWeight,
              targetReps: target == null
                  ? null
                  : "${target.targetRepsMin}-${target.targetRepsMax}",
            );
      },
      icon: const Icon(LucideIcons.plus, size: 16),
      label: const Text("Ajouter une série"),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Bas d'écran — navigateur d'exercices, bouton fin de séance
// ═══════════════════════════════════════════════════════════════

class _NavigatorSection extends ConsumerWidget {
  const _NavigatorSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(sessionExercisesProvider);
    final total = exercisesAsync.value?.length ?? 0;
    final currentIndex = ref.watch(currentExerciseIndexProvider);
    final notifier = ref.read(currentExerciseIndexProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: total > 1 ? notifier.previous : null,
          icon: const Icon(LucideIcons.chevronLeft, size: AppSpacing.iconSm),
          label: const Text("Précédent"),
        ),
        Row(
          children: [
            for (var i = 0; i < total; i++)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == currentIndex
                      ? context.colorScheme.primary
                      : context.colorScheme.outlineVariant,
                ),
              ),
          ],
        ),
        TextButton.icon(
          onPressed: total > 1 ? notifier.next : null,
          label: const Text("Suivant"),
          icon: const Icon(LucideIcons.chevronRight, size: AppSpacing.iconSm),
        ),
      ],
    );
  }
}

class _FinishButton extends ConsumerWidget {
  const _FinishButton({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (session.status != SessionStatus.active) {
            context.showInfo("Reprends la séance avant de la terminer.");
            return;
          }
          await ref.read(activeSessionProvider.notifier).complete();
          if (context.mounted) context.pop();
        },
        child: const Text("Terminer la séance"),
      ),
    );
  }
}

String _formatWeight(double weight) {
  return weight % 1 == 0
      ? weight.toInt().toString()
      : weight.toStringAsFixed(1);
}

double _maxWeight(List<ExerciseSet> sets) {
  return sets.map((s) => s.weight).reduce((a, b) => a > b ? a : b);
}
