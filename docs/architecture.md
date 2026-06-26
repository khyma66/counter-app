# Architecture

## High-Level System

```text
Mobile App
├── Flutter UI
├── Local Session Store
├── Native Audio Engine
├── On-Device ML Pipeline
├── Offline Sync Queue
└── Supabase Client

Supabase Backend
├── Auth
├── Postgres
├── Edge Functions
├── Realtime
├── Storage for optional consented datasets
└── Validation / Trust Scoring
```

## Counting Architecture

The counter must be on-device and real-time.

```text
Microphone
→ 16 kHz mono frames
→ noise suppression
→ voice activity detection
→ mantra classifier
→ boundary detector
→ confidence smoother
→ count engine
→ local session store
```

## Count Engine Contract

The UI should not depend directly on ML internals. Use a stable engine interface.

```dart
abstract class ChantCounterEngine {
  Future<void> initialize(ChantCounterConfig config);
  Stream<ChantCountEvent> get events;
  Future<void> startSession(ChantSessionConfig session);
  Future<void> pauseSession();
  Future<void> resumeSession();
  Future<void> stopSession();
  Future<void> dispose();
}
```

## Event Types

```text
CHANT_DETECTED
UNCERTAIN_CHANT
NOISE_TOO_HIGH
PLAYBACK_RISK_HIGH
VOICE_MISMATCH
SESSION_SAVED
SYNC_PENDING
SYNC_COMPLETE
```

## Backend Responsibilities

The backend should not live-count audio. It should:

- authenticate users
- store sessions
- validate synced counts
- calculate verified counts
- update leaderboard rollups
- enforce premium group limits
- calculate trust scores
- store optional consented model feedback

## Local-First Storage

Use local storage as the source of truth during an active session.

Reason: if the app crashes, battery dies, or network drops, the user's session should not be lost.

## Sync Model

```text
Local session created
→ local count events recorded
→ periodic local save
→ pending_sync row created
→ upload when online
→ backend validates
→ local sync status updated
```

## Leaderboard Model

Separate counts:

- personal_count: what user sees for personal tracking
- auto_count: raw automatic counter output
- corrected_count: user-adjusted count
- verified_count: count accepted for leaderboard
- leaderboard_count: verified_count adjusted by trust rules if needed

## Trust Score

Trust score should be calculated from:

- average model confidence
- correction percentage
- playback risk
- voice match score
- count rate realism
- session duration consistency
- model version
- device consistency

## Premium Groups

Premium users can create custom groups.

Group types:

- family
- friends
- temple
- study_circle
- custom

Free users may join limited groups. Premium users can create more groups and unlock advanced group analytics.

## Privacy

Default: do not upload raw audio.

Allowed data:

- session summaries
- confidence metrics
- per-minute counts
- model version
- optional local voice profile

Raw audio upload requires explicit opt-in consent.
