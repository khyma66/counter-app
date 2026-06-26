# Chanting Counter App - End-to-End Implementation Plan

## 1. Product Goal

Build a mobile chanting counter app that automatically detects live mantra chanting and increments counts without requiring manual tapping.

The product must support:

- Real-time automatic chant counting
- Offline-first session tracking
- Online sync for counts and leaderboards
- Verified leaderboard eligibility
- Premium custom family/friends groups
- Anti-cheat and anti-playback detection
- Long-term personalized chanting intelligence

## 2. Non-Negotiable Technical Decision

Do not use cloud speech-to-text as the core counting engine.

The live counter must run on-device:

```text
Mic audio
→ native audio engine
→ noise/VAD filter
→ mantra classifier
→ phrase boundary detector
→ confidence smoothing
→ count++
```

Cloud AI may be used later for spiritual guidance, summaries, and content, but not for live counting.

## 3. MVP Scope

### Included

- Flutter mobile app skeleton
- Supabase auth
- Local offline session storage
- Mock auto-counter engine interface
- Session start/stop
- Local count persistence
- Sync pending sessions when online
- Daily/weekly/monthly leaderboards
- Premium family/friends group model
- Correction percentage rules
- Trust score rules

### Excluded From MVP

- Production-grade TFLite model
- Full playback detection
- Temple onboarding
- AI spiritual coach
- App Store release automation

## 4. Recommended Stack

### Mobile

- Flutter for UI
- Native Android Kotlin module for AudioRecord
- Native iOS Swift module for AVAudioEngine
- SQLite/Drift for local storage
- TFLite/LiteRT for on-device inference

### Backend

- Supabase Auth
- Supabase Postgres
- Supabase Edge Functions
- Supabase Realtime for leaderboard updates
- Row Level Security for user/group data

### ML

- VAD model
- Mantra classifier
- Phrase boundary detector
- Playback/live-voice verifier
- User voice profile stored locally by default

## 5. Implementation Phases

### Phase 1 - Foundation

- Create Flutter app
- Add auth screens
- Add Supabase client
- Add local DB layer
- Add session model
- Add mocked auto-counter engine
- Add basic counter screen

### Phase 2 - Sync and Leaderboards

- Add offline sync queue
- Add session upload
- Add daily_user_counts
- Add weekly/monthly rollups
- Add leaderboard views
- Add conflict handling

### Phase 3 - Premium Groups

- Add groups
- Add group_members
- Add group_invites
- Add premium entitlement checks
- Add group leaderboards
- Add group challenges

### Phase 4 - Trust and Anti-Cheat

- Add session trust score
- Add correction percentage checks
- Add max realistic chants/minute validation
- Add playback risk fields
- Add verified_count vs personal_count separation

### Phase 5 - Native Audio Engine

- Implement Android audio stream
- Implement iOS audio stream
- Emit audio frames to Dart/native inference layer
- Add test harness using recorded WAV files

### Phase 6 - ML Prototype

- Train or integrate simple TFLite mantra detector
- Add phrase boundary detector
- Add calibration flow
- Add confidence meter

### Phase 7 - Production Hardening

- Battery optimization
- Background session save
- Crash recovery
- Analytics
- App store privacy disclosures
- Model versioning

## 6. Leaderboard Rules

Leaderboard ranking must use verified counts, not raw user-entered totals.

Correction percentage:

```text
abs(corrected_count - auto_count) / auto_count * 100
```

Recommended rules:

- 0-2% correction: global leaderboard eligible
- 2-5% correction: family/friends eligible, marked corrected
- 5-10% correction: personal stats only
- 10%+: not leaderboard eligible

## 7. Offline Sync Rules

Offline sessions must be allowed.

Stored locally:

- session_id
- user_id
- mantra_id
- started_at
- ended_at
- auto_count
- corrected_count
- verified_count
- avg_confidence
- correction_percentage
- model_version
- app_version
- device_hash
- per-minute count summaries

When internet returns:

```text
Local queue
→ Supabase Edge Function
→ validation engine
→ daily totals
→ leaderboard update
```

## 8. Anti-Playback Rules

Do not count YouTube, speaker playback, TV audio, or recorded audio for competitive leaderboards.

Detection layers:

- live voice score
- playback risk score
- distance/reverb estimate
- user voice match
- loop/repetition anomaly detection
- realistic speed check

Personal tracking may be more permissive. Competitive leaderboards must be strict.

## 9. Long-Term Moats

The app should become hard to copy through:

- personalized chanting profiles
- verified chanting dataset
- family/friends spiritual networks
- temple groups
- festival and regional intelligence
- spiritual knowledge graph
- historical progress and reputation

## 10. Immediate Codex Instruction

Codex should not implement the full product in one task.

Start with:

```text
Read docs/implementation-plan.md. Implement Phase 1 only: Flutter app skeleton, Supabase config placeholders, local session models, mocked auto-counter engine, and basic counter screen. Do not implement native audio yet.
```
