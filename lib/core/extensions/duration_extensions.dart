extension DurationFormatter on Duration {
  /// Formats a [Duration] as `HH:mm:ss`.
  ///
  /// Example: `Duration(seconds: 3661)` → `"01:01:01"`
  String toElapsedTimer() {
    final hours = inHours.remainder(100).toString().padLeft(2, "0");
    final minutes = inMinutes.remainder(60).toString().padLeft(2, "0");
    final seconds = inSeconds.remainder(60).toString().padLeft(2, "0");
    return "$hours:$minutes:$seconds";
  }
}
