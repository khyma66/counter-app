import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_counter/features/sessions/domain/chant_session.dart';

void main() {
  test('session serializes and deserializes', () {
    final session = ChantSession(
      id: 'session-1',
      mantraId: 'om-namah-shivaya',
      startedAt: DateTime.utc(2026, 8, 3, 12),
      endedAt: DateTime.utc(2026, 8, 3, 12, 5),
      count: 108,
    );

    final restored = ChantSession.fromJson(session.toJson());
    expect(restored.id, session.id);
    expect(restored.mantraId, session.mantraId);
    expect(restored.count, 108);
    expect(restored.duration, const Duration(minutes: 5));
  });
}
