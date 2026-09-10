enum TrainingGoal {
  strength("Force"),
  hypertrophy("Hypertrophie"),
  endurance("Endurance"),
  weightLoss("Perte de poids"),
  generalFitness("Remise en forme");

  const TrainingGoal(this.label);

  final String label;
}
