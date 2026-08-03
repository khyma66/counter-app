# Supabase setup

The app never stores Supabase credentials in source control.

## 1. Create or select a Supabase project

In the Supabase dashboard, enable **Authentication > Providers > Anonymous Sign-Ins**.

## 2. Apply the migration

Using the Supabase CLI from the repository root:

```bash
supabase link --project-ref YOUR_PROJECT_REF
supabase db push
```

Alternatively, paste `supabase/migrations/20260803223000_cloud_mvp.sql` into the Supabase SQL editor and run it once.

## 3. Run the Flutter app

Use the project URL and publishable/anon key from **Project Settings > API**:

```bash
cd mobile/app
flutter pub get
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLISHABLE_OR_ANON_KEY
```

The anon/publishable key is intended for client apps. Never place the service-role key in Flutter, GitHub, logs, or screenshots.

Without both build variables, the app starts in offline mode instead of crashing.

## Security behavior

- Anonymous authentication creates a unique Supabase user per installation/session persistence.
- Row-level security restricts session writes and reads to `auth.uid() = user_id`.
- The client cannot provide or use a service-role key.
- Session counts have database constraints, but serious anti-cheat requires server-side validation and signed audio/count evidence in a later phase.

## Production checklist

- Configure Android and iOS application identifiers.
- Add secure account upgrade/recovery so anonymous users do not lose identity after clearing app data.
- Add CI secrets only when integration tests require a dedicated test project.
- Add a server-controlled leaderboard RPC before exposing rankings publicly.
- Do not treat the current mock counter as verified chanting activity.
