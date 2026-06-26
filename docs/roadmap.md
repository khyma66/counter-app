# Roadmap

## Phase 1 - Foundation MVP

Goal: Build a working app shell with mocked auto-counting and backend-ready data models.

Deliverables:

- Flutter app skeleton
- Supabase configuration placeholders
- Auth screens
- Counter screen
- Session start/pause/stop
- Mock auto-counter engine
- Local session persistence
- Basic sync queue structure

Success Criteria:

- User can start a chanting session
- Mock counter increments automatically
- Session is saved locally
- App can show session history

## Phase 2 - Online Sync and Leaderboards

Deliverables:

- Supabase schema
- Session upload
- Daily rollups
- Weekly/monthly rollups
- Global leaderboard
- Sync status UI

Success Criteria:

- Offline session syncs after reconnect
- Leaderboard shows verified synced sessions
- Impossible counts are rejected or marked personal-only

## Phase 3 - Premium Groups

Deliverables:

- Group creation
- Invite links/codes
- Group membership
- Premium entitlement gates
- Family/friends leaderboards
- Group goals and milestones

Success Criteria:

- Premium user can create custom groups
- Members can join by invite
- Group leaderboard separates verified and corrected counts

## Phase 4 - Trust Score and Anti-Cheat

Deliverables:

- Trust score calculation
- Correction percentage rules
- Count-rate validation
- Playback risk fields
- Voice-match fields
- Session eligibility status

Success Criteria:

- Global leaderboard only uses verified sessions
- Suspicious sessions are visible to user but not ranked competitively

## Phase 5 - Native Audio Engine

Deliverables:

- Android AudioRecord module
- iOS AVAudioEngine module
- Audio frame streaming
- WAV test harness
- Battery-safe session saving

Success Criteria:

- Real microphone audio can be processed locally
- App handles session pause/resume/crash recovery

## Phase 6 - ML Prototype

Deliverables:

- VAD integration
- Mantra classifier prototype
- Phrase boundary detector prototype
- Confidence meter
- Calibration flow

Success Criteria:

- Quiet-room solo chanting reaches at least 90% count accuracy in controlled tests

## Phase 7 - Accuracy and Reliability

Deliverables:

- Personal thresholds
- Per-user calibration profile
- Noise handling
- Fast/strict modes
- Model versioning
- Correction analytics

Success Criteria:

- Quiet-room solo chanting reaches 94-96% in beta tests
- Fast chanting reaches at least 90% in beta tests

## Phase 8 - Playback and Fraud Resistance

Deliverables:

- Playback detection
- Live voice score
- Voice match score
- Loop anomaly detection
- Competitive leaderboard eligibility

Success Criteria:

- Obvious YouTube/speaker playback does not receive verified leaderboard credit

## Phase 9 - Community Moat

Deliverables:

- Family network features
- Temple groups
- Group challenges
- Regional/global challenges
- Seasonal festival campaigns

Success Criteria:

- Users return because their family/friends/temple network is active

## Phase 10 - Spiritual Intelligence

Deliverables:

- Preference profile
- Deity/tradition/language/region settings
- Festival reminders
- Personalized practice suggestions
- AI spiritual companion

Success Criteria:

- The app becomes a spiritual journey tool, not just a counter

## Phase 11 - Dataset and Model Moat

Deliverables:

- Optional dataset contribution consent
- Verified chanting metadata
- Model improvement pipeline
- Personalized model adaptation

Success Criteria:

- Counting accuracy improves with user base growth
- Competitors cannot easily replicate accumulated verified data
