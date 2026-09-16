class SessionTimerCalculator {
  const SessionTimerCalculator._();

  static Duration effectiveDuration({
    required DateTime startedAt,
    required int pausedDurationSeconds,
    DateTime? finishedAt,
  }) {
    final end = finishedAt ?? DateTime.now();
    return end.difference(startedAt) -
        Duration(seconds: pausedDurationSeconds);
  }
}
