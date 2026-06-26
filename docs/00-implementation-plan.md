# Counter App Implementation Plan

## Goal

Build a mobile chanting counter app that automatically counts mantra repetitions on-device, works offline, syncs verified counts online, supports leaderboards, and lets premium users create custom family/friends groups.

## Core Product Rules

- Auto-counting is the default experience.
- Counting must run on-device, not through GPT or cloud speech-to-text.
- Backend handles auth, sync, premium, groups, leaderboards, and validation.
- Manual corrections are allowed, but leaderboard eligibility must have limits.
- Offline sessions are allowed, but leaderboard inclusion happens only after sync and validation.
- Raw audio must not upload by default.
- Do not claim perfect accuracy.

## MVP Must-Haves

- Flutter mobile app.
- Supabase auth.
- Mantra selection.
- Live counter screen.
- Mocked `AutoCounterEngine` first.
- Local session storage.
- Offline sync queue.
- Supabase session sync.
- Personal stats.
- Verified leaderboard.
- Premium custom family/friends groups.
- Group leaderboards.
- Session trust score.

## MVP Cut

Do not build temple network, festival engine, AI spiritual companion, global heat map, or full anti-cheat perfection before the basic product works.

## Build Order

1. Repo docs and schema.
2. Flutter app skeleton.
3. Mock auto-counter interface.
4. Local session storage.
5. Supabase auth and sync.
6. Verified leaderboard.
7. Premium groups.
8. Native audio engine.
9. TFLite/LiteRT mantra detector prototype.
10. Calibration, confidence, anti-playback, and real-device testing.

## Accuracy Targets

Quiet solo chanting MVP target: 90-93%.
Strong v2 target: 95-98%.

Fast/noisy/group chanting should be treated more carefully. Group and playback audio should not qualify for competitive global leaderboards until properly verified.

## Leaderboard Correction Rules

Correction percentage:

```text
abs(corrected_count - auto_count) / auto_count * 100
```

Default rules:

- Global leaderboard: correction <= 2% and high trust score.
- Family/friends leaderboard: correction <= 5% by default.
- Personal stats: any correction allowed, but labeled.

## Long-Term Moat

Defensibility should come from personalized chanting profiles, verified chanting datasets, family/friends networks, temple communities, regional festival intelligence, and long-term spiritual progress history.
