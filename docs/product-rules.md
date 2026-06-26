# Product Rules

## 1. Counting Rules

The default user experience is automatic counting.

Manual tapping should not be required for normal usage.

A chant is counted only when the engine detects:

- selected mantra confidence above threshold
- phrase boundary confidence above threshold
- time since last count above minimum gap
- acceptable noise level
- acceptable playback/live-voice score for verified modes

## 2. Count Types

### Auto Count

Raw count produced by the automatic counter.

### Corrected Count

User-adjusted count after adding or subtracting corrections.

### Verified Count

Count accepted after validation.

### Leaderboard Count

Count eligible for competitive ranking.

## 3. Correction Rules

Formula:

```text
correction_percentage = abs(corrected_count - auto_count) / auto_count * 100
```

Rules:

- 0-2%: global leaderboard eligible
- 2-5%: family/friends leaderboard eligible, marked corrected
- 5-10%: personal stats only
- 10%+: invalid for competitive ranking

## 4. Offline Rules

Offline sessions are valid for personal tracking.

Offline sessions become leaderboard eligible only after successful sync and validation.

Status labels:

- local_only
- pending_sync
- synced
- verified
- rejected
- personal_only

## 5. Anti-Cheat Rules

Reject or downgrade sessions when:

- count rate exceeds realistic mantra speed
- playback risk is high
- voice match fails in competitive mode
- correction percentage exceeds thresholds
- session has impossible timestamps
- repeated perfect loop patterns are detected

## 6. Leaderboard Types

- Global daily
- Global weekly
- Global monthly
- Global all-time
- Family group
- Friends group
- Temple group
- Same-mantra leaderboard

Global boards must be stricter than private groups.

## 7. Premium Rules

Free users:

- auto counter
- personal history
- basic global leaderboard
- join limited groups

Premium users:

- create custom family/friends groups
- more group memberships
- private leaderboards
- group challenges
- advanced stats
- custom group goals
- future AI spiritual insights

## 8. Privacy Rules

Do not upload raw audio by default.

Voice profiles should remain local unless the user explicitly opts in.

Optional dataset contribution must clearly explain:

- what is uploaded
- why it is uploaded
- how it improves models
- how consent can be withdrawn

## 9. Spiritual UX Rules

The app should avoid turning chanting into only a vanity competition.

Leaderboards are useful, but spiritual progress should emphasize:

- consistency
- discipline
- family participation
- streaks
- personal goals
- verified effort, not fake high numbers
