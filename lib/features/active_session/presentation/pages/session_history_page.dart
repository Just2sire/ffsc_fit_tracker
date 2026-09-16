import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../core/utils/session_timer_calculator.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar;
import "../../domain/entities/workout_session.dart";
import "../providers/active_session_notifier.dart";

class SessionHistoryPage extends ConsumerWidget {
  const SessionHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(completedSessionsProvider);

    return AppScaffold(
      body: Column(
        children: [
          const AppTopbar(title: "Historique", showLeading: false),
          AppSpacing.gapVSm,
          Expanded(
            child: sessionsAsync.when(
              data: (sessions) {
                if (sessions.isEmpty) return const _EmptyState();
                return ListView.separated(
                  padding: const EdgeInsets.only(
                    bottom: AppSpacing.bottomScrollablePadding,
                  ),
                  itemCount: sessions.length,
                  separatorBuilder: (_, _) => AppSpacing.gapVMd,
                  itemBuilder: (context, index) =>
                      _SessionHistoryCard(session: sessions[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Erreur : $e")),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionHistoryCard extends StatelessWidget {
  const _SessionHistoryCard({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final duration = SessionTimerCalculator.effectiveDuration(
      startedAt: session.startedAt,
      pausedDurationSeconds: session.pausedDurationSeconds,
      finishedAt: session.finishedAt,
    );

    return Container(
      padding: AppSpacing.insetLg,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: AppSpacing.roundedLg,
      ),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.insetSm,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.check,
              color: colorScheme.primary,
              size: AppSpacing.iconMd,
            ),
          ),
          AppSpacing.gapHMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Text(
                  session.workoutDayNameSnapshot,
                  style: textTheme.titleMedium,
                ),
                Text(
                  _formatDate(session.finishedAt ?? session.startedAt),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(_formatDuration(duration), style: textTheme.bodyMedium),
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
              LucideIcons.rotateCcwClock,
              size: AppSpacing.iconXxl,
              color: colorScheme.onSurfaceVariant,
            ),
            Column(
              spacing: AppSpacing.sm,
              children: [
                Text(
                  "Aucune séance terminée",
                  style: textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Termine ta première séance\npour la voir apparaître ici.",
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

const _months = [
  "janv.",
  "févr.",
  "mars",
  "avr.",
  "mai",
  "juin",
  "juil.",
  "août",
  "sept.",
  "oct.",
  "nov.",
  "déc.",
];

String _formatDate(DateTime date) =>
    "${date.day} ${_months[date.month - 1]} ${date.year}";

String _formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (hours > 0) return "${hours}h${minutes.toString().padLeft(2, "0")}";
  return "$minutes min";
}
