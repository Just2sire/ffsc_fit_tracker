import "dart:convert";

import "package:drift/drift.dart";

import "../../../domain/enums/equipment.dart";
import "../../../domain/enums/muscle_group.dart";

/// Convertit une `List<String>` en JSON pour la stocker dans une colonne texte.
///
/// Utilisé pour `secondaryMuscles` et `instructionSteps`, dont le vocabulaire
/// (notamment les muscles secondaires) est plus large que l'enum [MuscleGroup]
/// et ne peut donc pas être stocké via `textEnum`.
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List).cast<String>();

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

/// Bibliothèque d'exercices, seedée depuis `assets/data/exercises.json`.
///
/// Soft delete uniquement : ne jamais `DELETE`, toujours passer par
/// `isArchived`.
class Exercises extends Table {
  /// UUID v4 généré au seed — jamais l'id brut du JSON.
  TextColumn get id => text()();

  /// Id d'origine du JSON ("0001"...), conservé pour traçabilité du seed.
  TextColumn get sourceId => text()();

  TextColumn get name => text()();

  /// = `category` / `body_part` du JSON (toujours identiques dans la source).
  TextColumn get bodyPart => text()();

  /// Muscle principal — basé sur le champ `target` 
  /// du JSON (19 valeurs fiables).
  TextColumn get muscleGroup => textEnum<MuscleGroup>()();

  /// Muscles secondaires — vocabulaire plus large que [MuscleGroup],
  /// stocké tel quel (libellés FR bruts du JSON) en JSON-encodé.
  TextColumn get secondaryMuscles => text().map(const StringListConverter())();

  TextColumn get equipment => textEnum<Equipment>()();

  TextColumn get instructions => text()();

  /// Étapes numérotées, JSON-encodées (champ `instruction_steps` du JSON).
  TextColumn get instructionSteps => text().map(const StringListConverter())();

  /// Chemin de l'asset image (`assets/images/exercises/...`).
  TextColumn get imageAsset => text()();

  /// Chemin de l'asset vidéo converti en mp4 (`assets/videos/exercises/...`),
  /// dérivé de `mediaId` — pas de `gif_url` (source en `.mp4`, jamais bundlé).
  TextColumn get videoAsset => text()();

  TextColumn get mediaId => text()();

  TextColumn get attribution => text()();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
