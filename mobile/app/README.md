# Mantra Counter mobile app

Flutter scaffold for the mantra chanting counter.

## Local validation

```bash
cd mobile/app
flutter pub get
flutter analyze
flutter test
flutter run
```

The app runs in offline mode by default.

## Supabase cloud sync

Apply the migration and follow the secure setup guide in `../../supabase/README.md`, then run:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLISHABLE_OR_ANON_KEY
```

Never commit a service-role key. The app intentionally falls back to offline mode when the two client build variables are absent.

## Current scope

Implemented:

- onboarding and mantra selection
- mocked automatic counter behind `AutoCounterEngine`
- session summary
- optional anonymous Supabase authentication
- secure session synchronization with row-level security
- session history and leaderboard repository queries
- CI analysis and tests

Not production-complete:

- real microphone/mantra recognition
- durable offline queue and retry
- account recovery/upgrade
- public leaderboard UI and anti-cheat validation
- premium groups and billing
- generated Android/iOS runner projects and store signing
