# Counter App

A mobile-first chanting counter app focused on accurate automatic mantra counting, offline-first sessions, verified online sync, competitive leaderboards, premium family/friends groups, anti-cheat validation, and long-term personalization.

## Product Direction

The app must not depend on cloud speech-to-text for live counting. Counting should happen on-device using native audio capture, local ML inference, phrase boundary detection, confidence scoring, and user calibration.

Backend services are responsible for authentication, sync, leaderboards, premium access, groups, trust scoring, analytics, and future model-improvement workflows.

## Core Principles

- Auto-counting is the primary experience.
- Manual correction is allowed but limited for leaderboard eligibility.
- Offline chanting must work reliably.
- Global leaderboards must use verified counts, not raw or unlimited manual counts.
- Raw audio should not be uploaded by default.
- Long-term defensibility comes from personalized models, verified data, family/temple networks, and spiritual journey features.

## Repo Structure

```text
counter-app/
├── docs/
│   ├── implementation-plan.md
│   ├── architecture.md
│   ├── roadmap.md
│   ├── codex-tasks.md
│   └── product-rules.md
├── backend/
│   └── supabase/
│       └── schema.sql
├── mobile/
│   └── README.md
├── ml/
│   └── README.md
└── README.md
```

## Immediate Build Order

1. Supabase schema and auth model
2. Flutter mobile skeleton
3. Local session storage and offline queue
4. Mock auto-counter engine interface
5. Session sync API
6. Daily/weekly/monthly leaderboard views
7. Premium family/friends groups
8. Trust score and anti-cheat validation
9. Native audio engine
10. TFLite mantra detector prototype

## Important Warning

Do not try to build the entire app in one giant AI task. Implement it phase by phase with tests and reviewable commits.
