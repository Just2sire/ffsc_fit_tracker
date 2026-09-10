/// Équipements d'entraînement.
///
/// Basé sur les 27 valeurs distinctes du champ `equipment` de
/// `assets/data/exercises.json`.
enum Equipment {
  assisted("assisté"),
  stabilityBall("ballon de stabilité"),
  resistanceBand("bande de résistance"),
  barbell("barre"),
  ezBar("barre EZ"),
  olympicBarbell("barre olympique"),
  trapBar("barre trap"),
  bosu("bosu"),
  rope("corde"),
  elliptical("elliptique"),
  upperBodyErgometer("ergomètre membre supérieur"),
  dumbbell("haltère"),
  kettlebell("kettlebell"),
  weightedVest("lest"),
  smithMachine("machine Smith"),
  leverMachine("machine à levier"),
  sledgehammer("marteau"),
  medicineBall("médecine-ball"),
  tire("pneu"),
  bodyweight("poids du corps"),
  cablePulley("poulie"),
  abWheel("roue abdominale"),
  foamRoller("rouleau"),
  skiErgometer("skierg"),
  stepper("stepper"),
  sled("traîneau"),
  stationaryBike("vélo stationnaire"),
  band("élastique");

  const Equipment(this.label);

  final String label;

  static Equipment fromLabel(String value) => values.firstWhere(
    (equipment) => equipment.label == value,
    orElse: () => throw ArgumentError("Équipement inconnu: $value"),
  );
}
