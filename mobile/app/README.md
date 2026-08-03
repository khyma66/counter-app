# Mantra Counter mobile app

Phase 2 Flutter skeleton for the chanting counter.

## Run

```bash
flutter pub get
flutter run
```

## Validate

```bash
flutter analyze
flutter test
```

The current `MockAutoCounterEngine` increments once per second. It deliberately contains no microphone or speech-recognition implementation. A native or on-device engine should later implement `AutoCounterEngine` without changing the UI flow.
