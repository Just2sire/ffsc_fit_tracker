// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sessionRepository)
final sessionRepositoryProvider = SessionRepositoryProvider._();

final class SessionRepositoryProvider
    extends
        $FunctionalProvider<
          SessionRepository,
          SessionRepository,
          SessionRepository
        >
    with $Provider<SessionRepository> {
  SessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionRepositoryHash();

  @$internal
  @override
  $ProviderElement<SessionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SessionRepository create(Ref ref) {
    return sessionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionRepository>(value),
    );
  }
}

String _$sessionRepositoryHash() => r'6b0104ea47a57d18b8a02302149851817a66c0b1';

@ProviderFor(pendingRecovery)
final pendingRecoveryProvider = PendingRecoveryProvider._();

final class PendingRecoveryProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkoutSession?>,
          WorkoutSession?,
          FutureOr<WorkoutSession?>
        >
    with $FutureModifier<WorkoutSession?>, $FutureProvider<WorkoutSession?> {
  PendingRecoveryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingRecoveryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingRecoveryHash();

  @$internal
  @override
  $FutureProviderElement<WorkoutSession?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WorkoutSession?> create(Ref ref) {
    return pendingRecovery(ref);
  }
}

String _$pendingRecoveryHash() => r'54b9c26075c73e7cfd3c4182b1ece6d5a01dedba';

@ProviderFor(ActiveSessionNotifier)
final activeSessionProvider = ActiveSessionNotifierProvider._();

final class ActiveSessionNotifierProvider
    extends $AsyncNotifierProvider<ActiveSessionNotifier, WorkoutSession?> {
  ActiveSessionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeSessionNotifierHash();

  @$internal
  @override
  ActiveSessionNotifier create() => ActiveSessionNotifier();
}

String _$activeSessionNotifierHash() =>
    r'59814b84c29b99bf69d4e7548f3aeb7798a3d8b5';

abstract class _$ActiveSessionNotifier extends $AsyncNotifier<WorkoutSession?> {
  FutureOr<WorkoutSession?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<WorkoutSession?>, WorkoutSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WorkoutSession?>, WorkoutSession?>,
              AsyncValue<WorkoutSession?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
