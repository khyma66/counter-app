import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_counter/core/counter/mock_auto_counter_engine.dart';

void main() {
  test('manual correction and reset update the count', () async {
    final engine = MockAutoCounterEngine();
    addTearDown(engine.dispose);

    await engine.correctCount(12);
    expect(engine.currentCount, 12);

    await engine.reset();
    expect(engine.currentCount, 0);
  });

  test('negative correction is rejected', () async {
    final engine = MockAutoCounterEngine();
    addTearDown(engine.dispose);

    expect(() => engine.correctCount(-1), throwsArgumentError);
  });
}
