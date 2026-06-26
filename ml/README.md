# ML and Audio Accuracy

This directory is for the chanting detection and evaluation pipeline.

## Core ML Goal

Detect completed mantra repetitions from live user chanting with high reliability.

The system should not rely on normal speech-to-text.

## Pipeline

```text
Audio sample
→ resample to 16 kHz mono
→ noise filtering
→ voice activity detection
→ mantra classifier
→ phrase boundary detector
→ confidence smoothing
→ count estimate
```

## Model Components

### 1. Voice Activity Detection

Detect speech/chanting vs silence/noise.

### 2. Mantra Classifier

Detect whether the selected mantra is being chanted.

### 3. Phrase Boundary Detector

Detect where one repetition ends and the next begins.

This is the most important part for fast chanting.

### 4. Playback / Live Voice Verifier

Detect YouTube, speaker playback, TV audio, recordings, and suspicious loops.

### 5. User Calibration

Learn user-specific:

- speed
- pitch range
- pause pattern
- confidence threshold
- minimum gap between repetitions

## Evaluation Metrics

For every test clip:

- expected_count
- predicted_count
- absolute_error
- error_percentage
- false_positive_count
- false_negative_count
- average_confidence
- playback_false_accept_rate

## Accuracy Targets

MVP:

- quiet solo chanting: 90-93%

Good v1:

- quiet solo chanting: 94-96%
- fast solo chanting: 90-95%

Strong v2:

- calibrated solo chanting: 95-98%

Do not promise 99% until real-world testing proves it.

## Dataset Structure

```text
ml/datasets/
├── raw/
├── processed/
├── labels/
└── README.md
```

## Test Harness Goal

Codex should later create scripts that can run:

```bash
python evaluate_counting.py --audio sample.wav --expected-count 108 --mantra om_namah_shivaya
```

and output count accuracy metrics.

## Privacy Rule

Raw audio must require explicit user consent before upload.
