# Architecture

## System Overview

The app has three major layers:

1. Mobile app for user experience and on-device counting.
2. Supabase backend for auth, sync, groups, subscriptions, and leaderboards.
3. ML/audio layer for future real mantra detection.

## Mobile App

Use Flutter for the UI.

Core modules:

- Onboarding.
- Mantra selection.
- Live counter.
- Session summary.
- Personal stats.
- Leaderboards.
- Premium groups.
- Offline session storage.
- Sync queue.

The first version should use a mocked `AutoCounterEngine`. Real audio should be added later behind the same interface.

## Auto Counter Interface

The UI should depend on an interface, not directly on microphone code.

Expected events:

- session started
- count incremented
- confidence updated
- uncertain count detected
- session stopped

## Future Audio Pipeline

The future native pipeline should follow this shape:

```text
microphone audio
→ normalize audio
→ detect voice activity
→ detect selected mantra
→ detect repetition boundary
→ smooth confidence
→ apply min-gap rule
→ increment count
```

## Backend

Supabase should manage:

- user profiles
- sessions
- count events
- daily summaries
- leaderboards
- groups
- group memberships
- invitations
- premium entitlements
- correction records
- session quality scores

## Offline Sync

The phone saves the session locally first. When internet returns, it syncs the session to Supabase.

Session states:

- local_only
- pending_sync
- synced
- rejected
- needs_review

The backend should use the final validated count for leaderboards.

## Leaderboard Principle

Personal stats can be flexible. Competitive rankings should be stricter and should use verified counts.

## Premium Groups

Premium users can create family/friends groups. Members can compare daily, weekly, and monthly verified counts.
