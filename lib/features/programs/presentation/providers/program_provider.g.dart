// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(programRepository)
final programRepositoryProvider = ProgramRepositoryProvider._();

final class ProgramRepositoryProvider
    extends
        $FunctionalProvider<
          ProgramRepository,
          ProgramRepository,
          ProgramRepository
        >
    with $Provider<ProgramRepository> {
  ProgramRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'programRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$programRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProgramRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProgramRepository create(Ref ref) {
    return programRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProgramRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProgramRepository>(value),
    );
  }
}

String _$programRepositoryHash() => r'ba5eda7f7bab499271f544dceb7d6378a5d90450';

/// Liste de tous les programmes actifs — se met à jour automatiquement
/// dès qu'un programme est créé, modifié ou archivé.

@ProviderFor(programsStream)
final programsStreamProvider = ProgramsStreamProvider._();

/// Liste de tous les programmes actifs — se met à jour automatiquement
/// dès qu'un programme est créé, modifié ou archivé.

final class ProgramsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WorkoutProgram>>,
          List<WorkoutProgram>,
          Stream<List<WorkoutProgram>>
        >
    with
        $FutureModifier<List<WorkoutProgram>>,
        $StreamProvider<List<WorkoutProgram>> {
  /// Liste de tous les programmes actifs — se met à jour automatiquement
  /// dès qu'un programme est créé, modifié ou archivé.
  ProgramsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'programsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$programsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<WorkoutProgram>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<WorkoutProgram>> create(Ref ref) {
    return programsStream(ref);
  }
}

String _$programsStreamHash() => r'53ddd2c123e10111f7a9b83659b5a578d3ba3390';

/// Jours d'un programme donné, ordonnés par [WorkoutDay.dayOrder].
/// Se met à jour automatiquement dès qu'un jour est ajouté / réordonné.

@ProviderFor(programDaysStream)
final programDaysStreamProvider = ProgramDaysStreamFamily._();

/// Jours d'un programme donné, ordonnés par [WorkoutDay.dayOrder].
/// Se met à jour automatiquement dès qu'un jour est ajouté / réordonné.

final class ProgramDaysStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WorkoutDay>>,
          List<WorkoutDay>,
          Stream<List<WorkoutDay>>
        >
    with $FutureModifier<List<WorkoutDay>>, $StreamProvider<List<WorkoutDay>> {
  /// Jours d'un programme donné, ordonnés par [WorkoutDay.dayOrder].
  /// Se met à jour automatiquement dès qu'un jour est ajouté / réordonné.
  ProgramDaysStreamProvider._({
    required ProgramDaysStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'programDaysStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$programDaysStreamHash();

  @override
  String toString() {
    return r'programDaysStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<WorkoutDay>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<WorkoutDay>> create(Ref ref) {
    final argument = this.argument as String;
    return programDaysStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProgramDaysStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$programDaysStreamHash() => r'9132c3c57865b4c8eab0b7e46617fb9ae42c148f';

/// Jours d'un programme donné, ordonnés par [WorkoutDay.dayOrder].
/// Se met à jour automatiquement dès qu'un jour est ajouté / réordonné.

final class ProgramDaysStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<WorkoutDay>>, String> {
  ProgramDaysStreamFamily._()
    : super(
        retry: null,
        name: r'programDaysStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Jours d'un programme donné, ordonnés par [WorkoutDay.dayOrder].
  /// Se met à jour automatiquement dès qu'un jour est ajouté / réordonné.

  ProgramDaysStreamProvider call(String programId) =>
      ProgramDaysStreamProvider._(argument: programId, from: this);

  @override
  String toString() => r'programDaysStreamProvider';
}

/// Nombre total de jours actifs — toutes programmes confondus.

@ProviderFor(totalDaysCount)
final totalDaysCountProvider = TotalDaysCountProvider._();

/// Nombre total de jours actifs — toutes programmes confondus.

final class TotalDaysCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Nombre total de jours actifs — toutes programmes confondus.
  TotalDaysCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalDaysCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalDaysCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return totalDaysCount(ref);
  }
}

String _$totalDaysCountHash() => r'5c63c293ff9d63c54b51ba6488fbd4c408454f36';

/// Programme par ID — utilisé pour les écrans de détail / édition.

@ProviderFor(programById)
final programByIdProvider = ProgramByIdFamily._();

/// Programme par ID — utilisé pour les écrans de détail / édition.

final class ProgramByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkoutProgram?>,
          WorkoutProgram?,
          FutureOr<WorkoutProgram?>
        >
    with $FutureModifier<WorkoutProgram?>, $FutureProvider<WorkoutProgram?> {
  /// Programme par ID — utilisé pour les écrans de détail / édition.
  ProgramByIdProvider._({
    required ProgramByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'programByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$programByIdHash();

  @override
  String toString() {
    return r'programByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<WorkoutProgram?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WorkoutProgram?> create(Ref ref) {
    final argument = this.argument as String;
    return programById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProgramByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$programByIdHash() => r'b4fa561b9c1fa2a1fbeb3e82471d4b5ad77ec69b';

/// Programme par ID — utilisé pour les écrans de détail / édition.

final class ProgramByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<WorkoutProgram?>, String> {
  ProgramByIdFamily._()
    : super(
        retry: null,
        name: r'programByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Programme par ID — utilisé pour les écrans de détail / édition.

  ProgramByIdProvider call(String id) =>
      ProgramByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'programByIdProvider';
}

/// Exercices prescrits pour un jour, ordonnés par [ProgramExercise.sortOrder].

@ProviderFor(exercisesForDay)
final exercisesForDayProvider = ExercisesForDayFamily._();

/// Exercices prescrits pour un jour, ordonnés par [ProgramExercise.sortOrder].

final class ExercisesForDayProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProgramExercise>>,
          List<ProgramExercise>,
          FutureOr<List<ProgramExercise>>
        >
    with
        $FutureModifier<List<ProgramExercise>>,
        $FutureProvider<List<ProgramExercise>> {
  /// Exercices prescrits pour un jour, ordonnés par [ProgramExercise.sortOrder].
  ExercisesForDayProvider._({
    required ExercisesForDayFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'exercisesForDayProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exercisesForDayHash();

  @override
  String toString() {
    return r'exercisesForDayProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ProgramExercise>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProgramExercise>> create(Ref ref) {
    final argument = this.argument as String;
    return exercisesForDay(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExercisesForDayProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exercisesForDayHash() => r'1c468123925a480e7b5b5c6510c2d0c25d2df1fe';

/// Exercices prescrits pour un jour, ordonnés par [ProgramExercise.sortOrder].

final class ExercisesForDayFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ProgramExercise>>, String> {
  ExercisesForDayFamily._()
    : super(
        retry: null,
        name: r'exercisesForDayProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Exercices prescrits pour un jour, ordonnés par [ProgramExercise.sortOrder].

  ExercisesForDayProvider call(String workoutDayId) =>
      ExercisesForDayProvider._(argument: workoutDayId, from: this);

  @override
  String toString() => r'exercisesForDayProvider';
}

/// Notifier centralisant toutes les opérations d'écriture du module.
///
/// Expose un [AsyncValue<void>] pour que l'UI puisse afficher un indicateur
/// de chargement et intercepter les erreurs sans logique try/catch dispersée.
///
/// Les streams ([programsStreamProvider], [programDaysStreamProvider])
/// se rafraîchissent automatiquement après chaque mutation — pas besoin
/// d'invalidation manuelle.

@ProviderFor(ProgramMutations)
final programMutationsProvider = ProgramMutationsProvider._();

/// Notifier centralisant toutes les opérations d'écriture du module.
///
/// Expose un [AsyncValue<void>] pour que l'UI puisse afficher un indicateur
/// de chargement et intercepter les erreurs sans logique try/catch dispersée.
///
/// Les streams ([programsStreamProvider], [programDaysStreamProvider])
/// se rafraîchissent automatiquement après chaque mutation — pas besoin
/// d'invalidation manuelle.
final class ProgramMutationsProvider
    extends $NotifierProvider<ProgramMutations, AsyncValue<void>> {
  /// Notifier centralisant toutes les opérations d'écriture du module.
  ///
  /// Expose un [AsyncValue<void>] pour que l'UI puisse afficher un indicateur
  /// de chargement et intercepter les erreurs sans logique try/catch dispersée.
  ///
  /// Les streams ([programsStreamProvider], [programDaysStreamProvider])
  /// se rafraîchissent automatiquement après chaque mutation — pas besoin
  /// d'invalidation manuelle.
  ProgramMutationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'programMutationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$programMutationsHash();

  @$internal
  @override
  ProgramMutations create() => ProgramMutations();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$programMutationsHash() => r'b00ea2c8ff9ad25f9e4119c73ea72844e95d1710';

/// Notifier centralisant toutes les opérations d'écriture du module.
///
/// Expose un [AsyncValue<void>] pour que l'UI puisse afficher un indicateur
/// de chargement et intercepter les erreurs sans logique try/catch dispersée.
///
/// Les streams ([programsStreamProvider], [programDaysStreamProvider])
/// se rafraîchissent automatiquement après chaque mutation — pas besoin
/// d'invalidation manuelle.

abstract class _$ProgramMutations extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
