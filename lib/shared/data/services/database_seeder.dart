import "dart:convert";

import "package:flutter/services.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:uuid/uuid.dart";

import "../database/app_database.dart";
import "../database/daos/exercise_dao.dart";
import "exercise_mapper.dart";

class DatabaseSeeder {
  DatabaseSeeder(this._dao);

  static const _seedKey = "db_seed_key";

  final ExerciseDao _dao;

  Future<void> seedIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_seedKey) == true) return;

    final raw = await rootBundle.loadString("assets/data/exercises.json");
    final list = jsonDecode(raw) as List<Map<String, Object?>>;
    // final list = jsonDecode(raw) as List<dynamic>;

    const uuid = Uuid();

    final exercises = list.map((exo) {
      final json = exo as Map<String, dynamic>;
      return Exercise(
        id: uuid.v4(),
        sourceId: json["id"] as String,
        name: json["name"] as String,
        bodyPart: json["body_part"] as String,
        muscleGroup: ExerciseMapper.parseMuscleGroup(json["target"] as String),
        secondaryMuscles: (json["secondary_muscles"] as List<dynamic>)
            .cast<String>(),
        equipment: ExerciseMapper.parseEquipment(json["equipment"] as String),
        instructions: json["instructions"] as String,
        instructionSteps: (json["instruction_steps"] as List<dynamic>)
            .cast<String>(),
        imageAsset: "assets/images/exercises/${json["image"]}",
        videoAsset: "assets/videos/exercises/${json["gif_url"]}",
        mediaId: json["media_id"] as String,
        attribution: json["attribution"] as String,
        isArchived: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).toList();

    await _dao.insertBatch(exercises);

    await prefs.setBool(_seedKey, true);
  }
}
