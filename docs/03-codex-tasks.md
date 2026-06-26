# Codex Task Guide

## Rule

Do not ask Codex to build the whole app in one task. Use one issue per task.

## First Task

Prompt:

```text
Read README.md and docs/*.md. Implement Phase 2 only: create a Flutter app skeleton under mobile/app with onboarding, mantra selection, live counter, session summary, leaderboard placeholder, and groups placeholder. Add an AutoCounterEngine interface with a mocked implementation that increments counts on a timer for demo/testing. Add basic tests. Do not implement real microphone audio yet. Open a PR referencing issue #2.
```

## Second Task

```text
Implement local session storage for the Flutter app. Add a session model, local repository, session status enum, and pending sync queue abstraction. Keep Supabase integration mocked. Add tests.
```

## Third Task

```text
Implement Supabase auth wiring and environment variable placeholders. Do not hardcode Supabase URL or anon key. Add .env.example. Add a setup guide.
```

## Fourth Task

```text
Implement session sync to Supabase using the schema in backend/supabase/schema.sql. Sync must be idempotent by session_id. Add error handling for offline and retry states.
```

## Fifth Task

```text
Implement leaderboard reads using verified_count, not raw_count. Add daily, weekly, monthly tabs. Add placeholders for global and group leaderboard.
```

## Sixth Task

```text
Implement premium group creation UI and backend checks. Free users can join limited groups. Premium users can create custom family/friends groups. Backend must not trust client-only premium claims.
```

## Audio Task Later

```text
Add native audio engine scaffolding behind AutoCounterEngine. Android should use AudioRecord. iOS should use AVAudioEngine. Do not change UI contracts. Add sample-based tests before real microphone claims.
```

## Review Checklist

- Small PR.
- One issue referenced.
- No hardcoded secrets.
- Tests included when practical.
- No raw audio upload by default.
- No global leaderboard from unverified/manual count.
- No overbuilt future roadmap features in MVP PRs.
