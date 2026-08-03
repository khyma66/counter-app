import '../domain/chant_session.dart';

abstract interface class SessionRepository {
  Future<void> save(ChantSession session);
  Future<List<ChantSession>> list();
}

final class InMemorySessionRepository implements SessionRepository {
  final List<ChantSession> _sessions = [];

  @override
  Future<void> save(ChantSession session) async {
    _sessions.removeWhere((item) => item.id == session.id);
    _sessions.add(session);
  }

  @override
  Future<List<ChantSession>> list() async => List.unmodifiable(_sessions);
}
