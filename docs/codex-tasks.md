# Codex Task Plan

Use this file to drive implementation in small, reviewable tasks.

Do not ask Codex to build the entire product in one pass.

## Task 1 - Create Flutter App Skeleton

Prompt:

```text
Read README.md and docs/implementation-plan.md. Create the Flutter app under mobile/app. Add a clean folder structure for features: auth, counter, sessions, leaderboard, groups, settings. Add placeholder screens and navigation. Do not implement native audio yet.
```

Acceptance Criteria:

- Flutter project exists under mobile/app
- App builds locally
- Placeholder screens exist
- Navigation works
- No real Supabase credentials committed

## Task 2 - Add Core Domain Models

Prompt:

```text
Add Dart domain models for UserProfile, Mantra, ChantSession, ChantEvent, LocalSyncItem, LeaderboardEntry, Group, GroupMember, and TrustScore. Include JSON serialization and unit tests.
```

Acceptance Criteria:

- Models compile
- JSON serialization tests pass
- Models match backend schema names where possible

## Task 3 - Mock Auto Counter Engine

Prompt:

```text
Implement a ChantCounterEngine interface and a MockChantCounterEngine that emits automatic count events every configurable interval. Wire it into the counter screen so the counter increments without tapping.
```

Acceptance Criteria:

- Counter auto-increments in mock mode
- Start/pause/resume/stop work
- UI displays count and mock confidence

## Task 4 - Local Storage

Prompt:

```text
Add local storage for sessions and pending sync items using SQLite/Drift or a simple repository abstraction. Save active session state every few seconds.
```

Acceptance Criteria:

- Session survives app restart in development
- Completed sessions appear in history
- Pending sync queue is persisted

## Task 5 - Supabase Schema

Prompt:

```text
Use backend/supabase/schema.sql as the base. Review and refine the schema for auth-linked profiles, sessions, counts, groups, memberships, invites, subscriptions, and trust scoring. Add RLS policies where appropriate.
```

Acceptance Criteria:

- Schema is valid Postgres SQL
- RLS is enabled for user-owned tables
- Group data access is membership-based

## Task 6 - Sync API Layer

Prompt:

```text
Implement a Supabase sync repository in the Flutter app. It should upload pending sessions, handle validation status returned from backend, and update local sync status.
```

Acceptance Criteria:

- Pending sessions upload when online
- Sync failures remain queued
- UI shows pending/synced/verified/personal-only statuses

## Task 7 - Leaderboards

Prompt:

```text
Implement leaderboard screens for daily, weekly, monthly, global, and group leaderboards. Use mock data first, then wire to Supabase views.
```

Acceptance Criteria:

- Leaderboard UI exists
- Filter by time range and group
- Shows verified count and trust indicators

## Task 8 - Premium Groups

Prompt:

```text
Implement group creation, invite code entry, group member list, and premium gating rules. Premium entitlement can be mocked initially.
```

Acceptance Criteria:

- User can create a group in mock/premium mode
- Invite codes can be entered
- Group leaderboard screen exists
- Non-premium limits are enforced in app logic

## Task 9 - Native Audio Placeholder

Prompt:

```text
Add platform channel interfaces for Android and iOS native audio engines. Implement stubs only. Do not add real microphone logic yet.
```

Acceptance Criteria:

- Dart interface exists
- Android/iOS stubs compile
- Mock engine remains default

## Task 10 - Real Android Audio Prototype

Prompt:

```text
Implement Android AudioRecord-based frame capture at 16 kHz mono. Stream frame metadata to Dart or native inference layer. Include permission handling and a debug screen.
```

Acceptance Criteria:

- Microphone permission requested correctly
- Audio frames are captured on Android
- Debug screen shows frame activity

## Task 11 - ML Test Harness

Prompt:

```text
Create an ML test harness under ml/ for evaluating WAV files with expected chant counts. Include placeholder scripts, dataset structure, and evaluation metrics.
```

Acceptance Criteria:

- Test folder structure exists
- Evaluation script accepts audio path and expected count
- Metrics include count error percentage

## Task 12 - Trust Score Engine

Prompt:

```text
Implement trust score calculation using confidence, correction percentage, playback risk, voice match score, count rate, and session duration. Add unit tests.
```

Acceptance Criteria:

- Suspicious sessions are downgraded
- Clean high-confidence sessions are eligible
- Tests cover boundary cases
