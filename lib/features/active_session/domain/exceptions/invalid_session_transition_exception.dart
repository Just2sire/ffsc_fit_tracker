import "package:fit_tracker/shared/domain/enums/session_status.dart";

class InvalidSessionTransitionException implements Exception {
  const InvalidSessionTransitionException({
    required this.from,
    required this.attempted,
  });

  final SessionStatus from;
  final String attempted;

  @override
  String toString() =>
      "InvalidSessionTransitionException: ${from.name} -> $attempted";
}
