enum MuscleGroup {
  abs("abdominaux"),
  abductors("abducteurs"),
  adductors("adducteurs"),
  forearms("avant-bras"),
  biceps("biceps"),
  spine("colonne vertébrale"),
  shoulders("deltoïdes"),
  back("dorsaux"),
  glutes("fessiers"),
  serratusAnterior("grand dentelé"),
  upperBack("haut du dos"),
  hamstrings("ischio-jambiers"),
  calves("mollets"),
  chest("pectoraux"),
  quadriceps("quadriceps"),
  cardiovascularSystem("système cardiovasculaire"),
  traps("trapèzes"),
  triceps("triceps"),
  scapulaElevator("élévateur de la scapula");

  const MuscleGroup(this.label);

  final String label;

  static MuscleGroup fromLabel(String value) => values.firstWhere(
    (group) => group.label == value,
    orElse: () => throw ArgumentError("Groupe musculaire inconnu: $value"),
  );
}
