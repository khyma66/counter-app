# Mobile App

The mobile app should be built with Flutter, with native modules for real-time audio capture and on-device inference.

## Intended Structure

```text
mobile/app/
├── lib/
│   ├── app/
│   ├── core/
│   ├── features/
│   │   ├── auth/
│   │   ├── counter/
│   │   ├── sessions/
│   │   ├── leaderboard/
│   │   ├── groups/
│   │   └── settings/
│   └── main.dart
├── android/
├── ios/
└── test/
```

## First Implementation Target

Do not start with real microphone counting.

Start with a mocked automatic counter engine so the product flow can be built and tested.

```text
Start session
→ mock engine emits count events
→ UI increments automatically
→ local session is saved
→ pending sync row is created
```

## Required App Features

- Auth
- Counter screen
- Auto-counting interface
- Session history
- Offline session save
- Pending sync status
- Global leaderboard
- Group leaderboard
- Premium group creation
- Settings and calibration placeholders

## Counter Engine Interface

The UI should depend on an abstract interface so the implementation can switch between mock, WAV-test, Android audio, iOS audio, and TFLite modes.

## Native Audio Later

Android:

- Kotlin
- AudioRecord
- 16 kHz mono
- frame size 20-40 ms

IOS:

- Swift
- AVAudioEngine
- 16 kHz mono
- frame size 20-40 ms

## Privacy

The app should not upload raw microphone audio by default.
