enum ProgressionTrend { noHistory, firstReference, increase, same, decrease }

class ProgressionSuggestion {
  const ProgressionSuggestion({
    required this.trend,
    required this.rationale,
    this.suggestedWeight,
  });

  final ProgressionTrend trend;
  final String rationale;
  final double? suggestedWeight;
}
