import 'dart:async';

import 'auto_counter_engine.dart';

final class MockAutoCounterEngine implements AutoCounterEngine {
  final StreamController<int> _controller = StreamController<int>.broadcast();
  Timer? _timer;
  int _count = 0;

  @override
  Stream<int> get countStream => _controller.stream;

  @override
  int get currentCount => _count;

  @override
  bool get isRunning => _timer?.isActive ?? false;

  @override
  Future<void> start() async {
    if (isRunning) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _count += 1;
      _controller.add(_count);
    });
  }

  @override
  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> reset() async {
    _count = 0;
    _controller.add(_count);
  }

  @override
  Future<void> correctCount(int value) async {
    if (value < 0) throw ArgumentError.value(value, 'value', 'must be non-negative');
    _count = value;
    _controller.add(_count);
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _controller.close();
  }
}
