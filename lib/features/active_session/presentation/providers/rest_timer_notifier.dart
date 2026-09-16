import "dart:async";

import "package:flutter/services.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/constants/notification_channels.dart";
import "../../../../shared/presentation/providers/notification_providers.dart";

part "rest_timer_notifier.g.dart";

class RestTimerState {
  const RestTimerState({
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.exerciseName,
  });

  final int totalSeconds;
  final int remainingSeconds;
  final String exerciseName;
}

@riverpod
class RestTimerNotifier extends _$RestTimerNotifier {
  Timer? _ticker;
  bool _hapticFired = false;

  @override
  RestTimerState? build() {
    ref.onDispose(() => _ticker?.cancel());
    return null;
  }

  Future<void> start(Duration duration, {required String exerciseName}) async {
    _ticker?.cancel();
    _hapticFired = false;
    final seconds = duration.inSeconds;
    state = RestTimerState(
      totalSeconds: seconds,
      remainingSeconds: seconds,
      exerciseName: exerciseName,
    );
    await _scheduleNotification(duration, exerciseName);
    _startTicking();
  }

  Future<void> addTime(Duration extra) async {
    final current = state;
    if (current == null) return;
    final newRemaining = current.remainingSeconds + extra.inSeconds;
    if (newRemaining > 5) _hapticFired = false;
    state = RestTimerState(
      totalSeconds: current.totalSeconds + extra.inSeconds,
      remainingSeconds: newRemaining,
      exerciseName: current.exerciseName,
    );
    await _scheduleNotification(
      Duration(seconds: newRemaining),
      current.exerciseName,
    );
  }

  Future<void> skip() async {
    _ticker?.cancel();
    state = null;
    await ref
        .read(notificationServiceProvider)
        .cancel(NotificationId.restTimerEnd);
  }

  void _startTicking() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state;
      if (current == null) return;
      final remaining = current.remainingSeconds - 1;

      if (remaining <= 5 && remaining > 0 && !_hapticFired) {
        _hapticFired = true;
        HapticFeedback.vibrate();
      }

      if (remaining <= 0) {
        _ticker?.cancel();
        state = null;
        return;
      }
      state = RestTimerState(
        totalSeconds: current.totalSeconds,
        remainingSeconds: remaining,
        exerciseName: current.exerciseName,
      );
    });
  }

  Future<void> _scheduleNotification(
    Duration delay,
    String exerciseName,
  ) async {
    final service = ref.read(notificationServiceProvider);
    await service.cancel(NotificationId.restTimerEnd);
    await service.schedule(
      id: NotificationId.restTimerEnd,
      title: "Repos terminé",
      body: "Reprends $exerciseName !",
      scheduledDate: DateTime.now().add(delay),
      channelId: NotificationChannel.alertsId,
    );
  }
}
