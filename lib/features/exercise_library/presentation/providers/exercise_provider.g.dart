// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(exerciseRepository)
final exerciseRepositoryProvider = ExerciseRepositoryProvider._();

final class ExerciseRepositoryProvider
    extends
        $FunctionalProvider<
          ExerciseRepository,
          ExerciseRepository,
          ExerciseRepository
        >
    with $Provider<ExerciseRepository> {
  ExerciseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExerciseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExerciseRepository create(Ref ref) {
    return exerciseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExerciseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExerciseRepository>(value),
    );
  }
}

String _$exerciseRepositoryHash() =>
    r'c24cec8d447d04a9eb4215b19c5f1eee9fa2d3a1';

@ProviderFor(exerciseById)
final exerciseByIdProvider = ExerciseByIdFamily._();

final class ExerciseByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Exercise?>,
          Exercise?,
          FutureOr<Exercise?>
        >
    with $FutureModifier<Exercise?>, $FutureProvider<Exercise?> {
  ExerciseByIdProvider._({
    required ExerciseByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'exerciseByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exerciseByIdHash();

  @override
  String toString() {
    return r'exerciseByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Exercise?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Exercise?> create(Ref ref) {
    final argument = this.argument as String;
    return exerciseById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exerciseByIdHash() => r'93db9f656bc9105f14613a39f4785092446aa415';

final class ExerciseByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Exercise?>, String> {
  ExerciseByIdFamily._()
    : super(
        retry: null,
        name: r'exerciseByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExerciseByIdProvider call(String id) =>
      ExerciseByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'exerciseByIdProvider';
}

@ProviderFor(ExercisesList)
final exercisesListProvider = ExercisesListProvider._();

final class ExercisesListProvider
    extends $AsyncNotifierProvider<ExercisesList, List<Exercise>> {
  ExercisesListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exercisesListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exercisesListHash();

  @$internal
  @override
  ExercisesList create() => ExercisesList();
}

String _$exercisesListHash() => r'449e6573557dfffa1e6e60e7026e55ecd164b115';

abstract class _$ExercisesList extends $AsyncNotifier<List<Exercise>> {
  FutureOr<List<Exercise>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Exercise>>, List<Exercise>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Exercise>>, List<Exercise>>,
              AsyncValue<List<Exercise>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ExerciseSearchQuery)
final exerciseSearchQueryProvider = ExerciseSearchQueryProvider._();

final class ExerciseSearchQueryProvider
    extends $NotifierProvider<ExerciseSearchQuery, String> {
  ExerciseSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exerciseSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exerciseSearchQueryHash();

  @$internal
  @override
  ExerciseSearchQuery create() => ExerciseSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$exerciseSearchQueryHash() =>
    r'a1c5f5947d6b5a992629714fd95bf8cae77084f4';

abstract class _$ExerciseSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(MuscleFilter)
final muscleFilterProvider = MuscleFilterProvider._();

final class MuscleFilterProvider
    extends $NotifierProvider<MuscleFilter, MuscleGroup?> {
  MuscleFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'muscleFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$muscleFilterHash();

  @$internal
  @override
  MuscleFilter create() => MuscleFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MuscleGroup? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MuscleGroup?>(value),
    );
  }
}

String _$muscleFilterHash() => r'9f7b2a9d34d2ed7b934f1ef706f9325e37a1a293';

abstract class _$MuscleFilter extends $Notifier<MuscleGroup?> {
  MuscleGroup? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MuscleGroup?, MuscleGroup?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MuscleGroup?, MuscleGroup?>,
              MuscleGroup?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(EquipmentFilter)
final equipmentFilterProvider = EquipmentFilterProvider._();

final class EquipmentFilterProvider
    extends $NotifierProvider<EquipmentFilter, Equipment?> {
  EquipmentFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'equipmentFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$equipmentFilterHash();

  @$internal
  @override
  EquipmentFilter create() => EquipmentFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Equipment? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Equipment?>(value),
    );
  }
}

String _$equipmentFilterHash() => r'aa18f4bbe26fedd41016fecdc8ab24b00cdb38e2';

abstract class _$EquipmentFilter extends $Notifier<Equipment?> {
  Equipment? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Equipment?, Equipment?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Equipment?, Equipment?>,
              Equipment?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredExercises)
final filteredExercisesProvider = FilteredExercisesProvider._();

final class FilteredExercisesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Exercise>>,
          List<Exercise>,
          FutureOr<List<Exercise>>
        >
    with $FutureModifier<List<Exercise>>, $FutureProvider<List<Exercise>> {
  FilteredExercisesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredExercisesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredExercisesHash();

  @$internal
  @override
  $FutureProviderElement<List<Exercise>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Exercise>> create(Ref ref) {
    return filteredExercises(ref);
  }
}

String _$filteredExercisesHash() => r'b2702e79b82742343372f8b411451e0d5fba7863';
