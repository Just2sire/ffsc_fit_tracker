enum SessionStatus {
  active("En cours"),
  paused("En pause"),
  completed("Terminée"),
  abandoned("Abandonnée");

  const SessionStatus(this.label);

  final String label;
}
