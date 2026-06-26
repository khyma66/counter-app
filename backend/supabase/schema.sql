-- Counter App Supabase Schema
-- Initial schema for automatic chanting counter, offline sync, leaderboards, groups, premium access, and trust scoring.

create extension if not exists "pgcrypto";

-- Profiles mirror auth.users through user_id.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  avatar_url text,
  country text,
  region text,
  language text,
  tradition text,
  deity_preference text,
  is_premium boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.mantras (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  canonical_text text not null,
  language text,
  default_count_unit text not null default 'full_mantra',
  expected_duration_min_ms integer,
  expected_duration_max_ms integer,
  max_verified_count_per_minute integer,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.chant_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  mantra_id uuid references public.mantras(id),
  client_session_id text not null,
  started_at timestamptz not null,
  ended_at timestamptz,
  duration_seconds integer,
  auto_count integer not null default 0,
  corrected_count integer,
  verified_count integer not null default 0,
  personal_count integer not null default 0,
  correction_percentage numeric(8,4),
  avg_confidence numeric(6,4),
  min_confidence numeric(6,4),
  max_confidence numeric(6,4),
  playback_risk_score numeric(6,4),
  live_voice_score numeric(6,4),
  voice_match_score numeric(6,4),
  trust_score numeric(6,4),
  eligibility_status text not null default 'pending_validation',
  sync_status text not null default 'pending_sync',
  session_mode text not null default 'auto',
  correction_mode text not null default 'none',
  device_hash text,
  device_model text,
  app_version text,
  model_version text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, client_session_id)
);

create table if not exists public.chant_session_minute_summaries (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.chant_sessions(id) on delete cascade,
  minute_index integer not null,
  auto_count integer not null default 0,
  accepted_count integer not null default 0,
  uncertain_count integer not null default 0,
  avg_confidence numeric(6,4),
  playback_risk_score numeric(6,4),
  noise_score numeric(6,4),
  created_at timestamptz not null default now(),
  unique(session_id, minute_index)
);

create table if not exists public.chant_corrections (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.chant_sessions(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  corrected_from integer not null,
  corrected_to integer not null,
  reason text,
  created_at timestamptz not null default now()
);

create table if not exists public.daily_user_counts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  mantra_id uuid references public.mantras(id),
  count_date date not null,
  personal_count integer not null default 0,
  verified_count integer not null default 0,
  session_count integer not null default 0,
  total_minutes integer not null default 0,
  avg_trust_score numeric(6,4),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, mantra_id, count_date)
);

create table if not exists public.groups (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  group_type text not null default 'custom',
  created_by uuid not null references public.profiles(id) on delete cascade,
  is_premium_group boolean not null default true,
  visibility text not null default 'private',
  invite_code text unique,
  max_members integer,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.group_members (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references public.groups(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role text not null default 'member',
  status text not null default 'active',
  joined_at timestamptz not null default now(),
  unique(group_id, user_id)
);

create table if not exists public.group_invites (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references public.groups(id) on delete cascade,
  invited_by uuid not null references public.profiles(id) on delete cascade,
  invite_code text not null unique,
  expires_at timestamptz,
  max_uses integer,
  use_count integer not null default 0,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.group_daily_counts (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references public.groups(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  mantra_id uuid references public.mantras(id),
  count_date date not null,
  personal_count integer not null default 0,
  verified_count integer not null default 0,
  avg_trust_score numeric(6,4),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(group_id, user_id, mantra_id, count_date)
);

create table if not exists public.subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  provider text not null,
  provider_customer_id text,
  provider_subscription_id text,
  plan_code text not null,
  status text not null,
  current_period_start timestamptz,
  current_period_end timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.user_voice_profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  mantra_id uuid references public.mantras(id),
  avg_speed numeric(8,4),
  avg_pitch_range numeric(8,4),
  confidence_threshold numeric(6,4),
  min_gap_ms integer,
  playback_risk_baseline numeric(6,4),
  model_version text,
  storage_location text not null default 'local_only',
  last_trained_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, mantra_id)
);

create table if not exists public.model_feedback_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete set null,
  session_id uuid references public.chant_sessions(id) on delete set null,
  mantra_id uuid references public.mantras(id),
  event_type text not null,
  payload jsonb not null default '{}'::jsonb,
  user_consented_audio boolean not null default false,
  created_at timestamptz not null default now()
);

-- Useful indexes
create index if not exists idx_chant_sessions_user_started on public.chant_sessions(user_id, started_at desc);
create index if not exists idx_chant_sessions_eligibility on public.chant_sessions(eligibility_status, started_at desc);
create index if not exists idx_daily_user_counts_date on public.daily_user_counts(count_date desc, verified_count desc);
create index if not exists idx_group_daily_counts_group_date on public.group_daily_counts(group_id, count_date desc, verified_count desc);
create index if not exists idx_group_members_user on public.group_members(user_id);

-- Enable RLS
alter table public.profiles enable row level security;
alter table public.chant_sessions enable row level security;
alter table public.chant_session_minute_summaries enable row level security;
alter table public.chant_corrections enable row level security;
alter table public.daily_user_counts enable row level security;
alter table public.groups enable row level security;
alter table public.group_members enable row level security;
alter table public.group_invites enable row level security;
alter table public.group_daily_counts enable row level security;
alter table public.subscriptions enable row level security;
alter table public.user_voice_profiles enable row level security;
alter table public.model_feedback_events enable row level security;

-- Basic user-owned policies. These are initial policies and should be tightened during backend implementation.
create policy "Users can read own profile" on public.profiles for select using (auth.uid() = id);
create policy "Users can update own profile" on public.profiles for update using (auth.uid() = id);

create policy "Users can read own sessions" on public.chant_sessions for select using (auth.uid() = user_id);
create policy "Users can insert own sessions" on public.chant_sessions for insert with check (auth.uid() = user_id);
create policy "Users can update own sessions" on public.chant_sessions for update using (auth.uid() = user_id);

create policy "Users can read own daily counts" on public.daily_user_counts for select using (auth.uid() = user_id);

create policy "Users can read memberships they belong to" on public.group_members for select using (auth.uid() = user_id);
create policy "Group creators can manage groups" on public.groups for all using (auth.uid() = created_by);

create policy "Users can read own subscriptions" on public.subscriptions for select using (auth.uid() = user_id);
create policy "Users can read own voice profiles" on public.user_voice_profiles for select using (auth.uid() = user_id);
create policy "Users can manage own voice profiles" on public.user_voice_profiles for all using (auth.uid() = user_id);

-- Seed starter mantras
insert into public.mantras (name, canonical_text, language, default_count_unit, expected_duration_min_ms, expected_duration_max_ms, max_verified_count_per_minute)
values
  ('Om Namah Shivaya', 'Om Namah Shivaya', 'Sanskrit', 'full_mantra', 700, 2500, 100),
  ('Hare Krishna Mahamantra', 'Hare Krishna Hare Krishna Krishna Krishna Hare Hare Hare Rama Hare Rama Rama Rama Hare Hare', 'Sanskrit', 'full_mahamantra', 6000, 20000, 12)
on conflict do nothing;
