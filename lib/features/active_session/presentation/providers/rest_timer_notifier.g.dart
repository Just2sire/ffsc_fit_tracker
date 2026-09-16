// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_timer_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RestTimerNotifier)
final restTimerProvider = RestTimerNotifierProvider._();

final class RestTimerNotifierProvider
    extends $NotifierProvider<RestTimerNotifier, RestTimerState?> {
  RestTimerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'restTimerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$restTimerNotifierHash();

  @$internal
  @override
  RestTimerNotifier create() => RestTimerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RestTimerState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RestTimerState?>(value),
    );
  }
}

String _$restTimerNotifierHash() => r'ca45e03f3bcd5218c2de9e0bdf21f2e8eefab46c';

abstract class _$RestTimerNotifier extends $Notifier<RestTimerState?> {
  RestTimerState? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RestTimerState?, RestTimerState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RestTimerState?, RestTimerState?>,
              RestTimerState?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
