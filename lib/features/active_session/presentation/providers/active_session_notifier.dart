import "dart:async";

import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/utils/session_timer_calculator.dart";
import "../../../../shared/domain/enums/index.dart";
import "../../../../shared/presentation/providers/database_providers.dart";
import "../../data/datasources/session_local_datasource.dart";
import "../../data/repositories/session_repository_impl.dart";
import "../../domain/entities/workout_session.dart";
import "../../domain/repositories/session_repository.dart";
import "../../domain/usecases/abandon_session_usecase.dart";
import "../../domain/usecases/complete_session_usecase.dart";
import "../../domain/usecases/pause_session_usecase.dart";
import "../../domain/usecases/recover_session_usecase.dart";
import "../../domain/usecases/resume_session_usecase.dart";
import "../../domain/usecases/start_session_usecase.dart";

part "active_session_notifier.g.dart";

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final datasource = SessionLocalDatasource(db);
  return SessionRepositoryImpl(datasource);
}

@riverpod
Future<WorkoutSession?> pendingRecovery(Ref ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return RecoverSessionUseCase(repository).call();
}

/// Séances terminées, les plus récentes en premier — pour l'historique.
@riverpod
Stream<List<WorkoutSession>> completedSessions(Ref ref) =>
    ref.watch(sessionRepositoryProvider).watchCompletedSessions();

@riverpod
Stream<Duration> sessionElapsedTime(Ref ref) async* {
  final session = ref.watch(activeSessionProvider).value;
  if (session == null) {
    yield Duration.zero;
    return;
  }

  Duration compute() => SessionTimerCalculator.effectiveDuration(
    startedAt: session.startedAt,
    pausedDurationSeconds: session.pausedDurationSeconds,
    finishedAt: session.status == SessionStatus.paused
        ? session.lastActiveAt
        : session.finishedAt,
  );

  yield compute();
  if (session.status != SessionStatus.active) return;

  yield* Stream.periodic(const Duration(seconds: 1), (_) => compute());
}

@Riverpod(keepAlive: true)
class ActiveSessionNotifier extends _$ActiveSessionNotifier {
  Timer? _heartbeatTimer;

  @override
  Future<WorkoutSession?> build() async {
    ref.onDispose(() => _heartbeatTimer?.cancel());
    final repository = ref.watch(sessionRepositoryProvider);
    final session = await repository.findActiveSession();
    if (session?.status == SessionStatus.active) _startHeartbeat();
    return session;
  }

  Future<void> start(String workoutDayId) async {
    if (state.isLoading) return;
    final repository = ref.read(sessionRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = await StartSessionUseCase(repository).call(workoutDayId);
      _startHeartbeat();
      return session;
    });
  }

  Future<void> pause() => _applyTransition(
    (repository, id) => PauseSessionUseCase(repository).call(id),
    onSuccess: _stopHeartbeat,
  );

  Future<void> resume() => _applyTransition(
    (repository, id) => ResumeSessionUseCase(repository).call(id),
    onSuccess: _startHeartbeat,
  );

  Future<void> complete() => _applyTransition(
    (repository, id) => CompleteSessionUseCase(repository).call(id),
    onSuccess: _stopHeartbeat,
  );

  Future<void> abandon() => _applyTransition(
    (repository, id) => AbandonSessionUseCase(repository).call(id),
    onSuccess: _stopHeartbeat,
  );

  Future<void> _applyTransition(
    Future<WorkoutSession> Function(SessionRepository repository, String id)
    transition, {
    required void Function() onSuccess,
  }) async {
    if (state.isLoading) return;
    final current = state.value;
    if (current == null) return;

    final repository = ref.read(sessionRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final updated = await transition(repository, current.id);
      onSuccess();
      return updated;
    });
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      final id = state.value?.id;
      if (id != null) ref.read(sessionRepositoryProvider).updateHeartbeat(id);
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }
}
