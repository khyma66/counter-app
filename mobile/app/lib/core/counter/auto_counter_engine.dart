abstract interface class AutoCounterEngine {
  Stream<int> get countStream;
  int get currentCount;
  bool get isRunning;

  Future<void> start();
  Future<void> stop();
  Future<void> reset();
  Future<void> correctCount(int value);
  Future<void> dispose();
}
