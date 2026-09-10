import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../shared/presentation/widgets/app_text_form_field.dart";
import "../providers/exercise_provider.dart";

class ExerciseSearchBar extends ConsumerWidget {
  const ExerciseSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppTextFormField(
      hintText: "Rechercher un exercice…",
      onChanged: (value) =>
          ref.read(exerciseSearchQueryProvider.notifier).set(value ?? ""),
    );
  }
}
