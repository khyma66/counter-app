# Product Rules

## Counting

- Auto-counting is the primary mode.
- Manual tap counting can exist as fallback, but not as the main experience.
- The app should count complete mantra repetitions, not random words.
- The definition of one count must be explicit per mantra.

## Correction Rules

Users can correct counts for personal tracking.

Leaderboard correction limits:

- Global: correction <= 2%.
- Family/friends: correction <= 5% by default.
- Personal stats: no strict correction limit, but clearly labeled.

## Count Categories

- Verified Auto Count.
- Auto + Corrected Count.
- Manual Count.

Only Verified Auto Count should be used for competitive global leaderboard by default.

## Offline Rules

- Counting must work without internet.
- Offline sessions are stored locally.
- Offline sessions sync later.
- Synced offline sessions should be validated before leaderboard inclusion.

## Playback and Background Audio

The app should not count YouTube, speaker playback, TV audio, or nearby group chanting as competitive verified count.

Personal stats may show uncertain counts, but leaderboards should be stricter.

## Premium Groups

Free users:

- Use core counter.
- See personal stats.
- Join limited groups.

Premium users:

- Create custom family/friends groups.
- Invite members.
- Create group challenges.
- View group analytics.

## Privacy

- Do not upload raw audio by default.
- Optional audio contribution requires explicit consent.
- Store metadata and model-quality signals by default.
- Provide deletion/export path later.

## Accuracy Claims

Do not claim 99% accuracy unless benchmarks prove it.

Use honest language:

- Assisted auto-counting.
- Verified count.
- Uncertain count.
- Correction percentage.
- Session quality score.
