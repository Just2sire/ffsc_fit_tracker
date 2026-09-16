// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_exercise_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sessionExercises)
final sessionExercisesProvider = SessionExercisesProvider._();

final class SessionExercisesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SessionExercise>>,
          List<SessionExercise>,
          FutureOr<List<SessionExercise>>
        >
    with
        $FutureModifier<List<SessionExercise>>,
        $FutureProvider<List<SessionExercise>> {
  SessionExercisesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionExercisesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionExercisesHash();

  @$internal
  @override
  $FutureProviderElement<List<SessionExercise>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SessionExercise>> create(Ref ref) {
    return sessionExercises(ref);
  }
}

String _$sessionExercisesHash() => r'7c06bbb18bd4b51165923af57e54a67127c0432f';

@ProviderFor(CurrentExerciseIndex)
final currentExerciseIndexProvider = CurrentExerciseIndexProvider._();

final class CurrentExerciseIndexProvider
    extends $NotifierProvider<CurrentExerciseIndex, int> {
  CurrentExerciseIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentExerciseIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentExerciseIndexHash();

  @$internal
  @override
  CurrentExerciseIndex create() => CurrentExerciseIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$currentExerciseIndexHash() =>
    r'c860119e74ec379f32f4997b0c7d8e0d39934772';

abstract class _$CurrentExerciseIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(currentSessionExercise)
final currentSessionExerciseProvider = CurrentSessionExerciseProvider._();

final class CurrentSessionExerciseProvider
    extends
        $FunctionalProvider<
          AsyncValue<SessionExercise?>,
          SessionExercise?,
          FutureOr<SessionExercise?>
        >
    with $FutureModifier<SessionExercise?>, $FutureProvider<SessionExercise?> {
  CurrentSessionExerciseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSessionExerciseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSessionExerciseHash();

  @$internal
  @override
  $FutureProviderElement<SessionExercise?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SessionExercise?> create(Ref ref) {
    return currentSessionExercise(ref);
  }
}

String _$currentSessionExerciseHash() =>
    r'd89a179937cb1ef4b6cf85c70d5465001fa3dc50';

@ProviderFor(currentExerciseTarget)
final currentExerciseTargetProvider = CurrentExerciseTargetProvider._();

final class CurrentExerciseTargetProvider
    extends
        $FunctionalProvider<
          AsyncValue<SessionExerciseTarget?>,
          SessionExerciseTarget?,
          FutureOr<SessionExerciseTarget?>
        >
    with
        $FutureModifier<SessionExerciseTarget?>,
        $FutureProvider<SessionExerciseTarget?> {
  CurrentExerciseTargetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentExerciseTargetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentExerciseTargetHash();

  @$internal
  @override
  $FutureProviderElement<SessionExerciseTarget?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SessionExerciseTarget?> create(Ref ref) {
    return currentExerciseTarget(ref);
  }
}

String _$currentExerciseTargetHash() =>
    r'fb342afc9c52c4003c327b49392be354f7a510bb';

@ProviderFor(currentExerciseHistory)
final currentExerciseHistoryProvider = CurrentExerciseHistoryProvider._();

final class CurrentExerciseHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<List<ExerciseSet>>>,
          List<List<ExerciseSet>>,
          FutureOr<List<List<ExerciseSet>>>
        >
    with
        $FutureModifier<List<List<ExerciseSet>>>,
        $FutureProvider<List<List<ExerciseSet>>> {
  CurrentExerciseHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentExerciseHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentExerciseHistoryHash();

  @$internal
  @override
  $FutureProviderElement<List<List<ExerciseSet>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<List<ExerciseSet>>> create(Ref ref) {
    return currentExerciseHistory(ref);
  }
}

String _$currentExerciseHistoryHash() =>
    r'0dfbbb8adebd4b39cd07f78a3c0fa5bf32cb7c5a';

@ProviderFor(currentProgressionSuggestion)
final currentProgressionSuggestionProvider =
    CurrentProgressionSuggestionProvider._();

final class CurrentProgressionSuggestionProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProgressionSuggestion?>,
          ProgressionSuggestion?,
          FutureOr<ProgressionSuggestion?>
        >
    with
        $FutureModifier<ProgressionSuggestion?>,
        $FutureProvider<ProgressionSuggestion?> {
  CurrentProgressionSuggestionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentProgressionSuggestionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentProgressionSuggestionHash();

  @$internal
  @override
  $FutureProviderElement<ProgressionSuggestion?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProgressionSuggestion?> create(Ref ref) {
    return currentProgressionSuggestion(ref);
  }
}

String _$currentProgressionSuggestionHash() =>
    r'5e7e9e02694338cf2805c1e0f196d4aa057cd635';

@ProviderFor(CurrentExerciseSets)
final currentExerciseSetsProvider = CurrentExerciseSetsProvider._();

final class CurrentExerciseSetsProvider
    extends $AsyncNotifierProvider<CurrentExerciseSets, List<ExerciseSet>> {
  CurrentExerciseSetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentExerciseSetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentExerciseSetsHash();

  @$internal
  @override
  CurrentExerciseSets create() => CurrentExerciseSets();
}

String _$currentExerciseSetsHash() =>
    r'f0a5946b161b51504fa8e47b4ae9ef5249c87ada';

abstract class _$CurrentExerciseSets extends $AsyncNotifier<List<ExerciseSet>> {
  FutureOr<List<ExerciseSet>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ExerciseSet>>, List<ExerciseSet>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ExerciseSet>>, List<ExerciseSet>>,
              AsyncValue<List<ExerciseSet>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
