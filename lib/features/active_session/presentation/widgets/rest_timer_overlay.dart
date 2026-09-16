import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../providers/rest_timer_notifier.dart";
import "circular_countdown.dart";

class RestTimerOverlay extends ConsumerWidget {
  const RestTimerOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(restTimerProvider);
    if (state == null) return const SizedBox.shrink();

    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final notifier = ref.read(restTimerProvider.notifier);
    final progress = state.remainingSeconds / state.totalSeconds;
    final minutes = (state.remainingSeconds ~/ 60).toString().padLeft(2, "0");
    final seconds = (state.remainingSeconds % 60).toString().padLeft(2, "0");

    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.6),
        child: Center(
          child: Container(
            margin: AppSpacing.insetXxl,
            padding: AppSpacing.insetXxl,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: AppSpacing.roundedXl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Temps de repos", style: textTheme.titleMedium),
                AppSpacing.gapVLg,
                CircularCountdown(
                  progress: progress,
                  label: "$minutes:$seconds",
                ),
                AppSpacing.gapVLg,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: AppSpacing.sm,
                  children: [
                    OutlinedButton(
                      onPressed: () =>
                          notifier.addTime(const Duration(seconds: 15)),
                      child: const Text("+15s"),
                    ),
                    OutlinedButton(
                      onPressed: () =>
                          notifier.addTime(const Duration(seconds: 30)),
                      child: const Text("+30s"),
                    ),
                    TextButton(
                      onPressed: notifier.skip,
                      child: const Text("Sauter"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
