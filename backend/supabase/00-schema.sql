-- Counter App initial Supabase schema

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  plan text not null default 'free',
  created_at timestamptz not null default now()
);

create table if not exists public.mantras (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  count_unit text not null default 'full_repetition',
  language text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.chant_sessions (
  id uuid primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  mantra_id uuid references public.mantras(id),
  started_at timestamptz not null,
  ended_at timestamptz,
  raw_count integer not null default 0,
  corrected_count integer,
  verified_count integer not null default 0,
  uncertain_count integer not null default 0,
  average_confidence numeric,
  correction_percent numeric,
  trust_score numeric,
  sync_status text not null default 'pending_sync',
  model_version text,
  app_version text,
  device_hash text,
  created_at timestamptz not null default now()
);

create table if not exists public.groups (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  name text not null,
  group_type text not null default 'family',
  is_premium_group boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.group_members (
  group_id uuid not null references public.groups(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role text not null default 'member',
  joined_at timestamptz not null default now(),
  primary key (group_id, user_id)
);

create table if not exists public.group_invites (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references public.groups(id) on delete cascade,
  invite_code text not null unique,
  created_by uuid not null references public.profiles(id) on delete cascade,
  expires_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.daily_user_counts (
  user_id uuid not null references public.profiles(id) on delete cascade,
  date date not null,
  verified_count integer not null default 0,
  raw_count integer not null default 0,
  corrected_count integer not null default 0,
  primary key (user_id, date)
);

create table if not exists public.corrections (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.chant_sessions(id) on delete cascade,
  corrected_from integer not null,
  corrected_to integer not null,
  reason text,
  created_at timestamptz not null default now()
);

create table if not exists public.user_calibration_profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  mantra_id uuid references public.mantras(id),
  average_speed_ms integer,
  confidence_threshold numeric,
  min_gap_ms integer,
  model_version text,
  updated_at timestamptz not null default now()
);

create index if not exists chant_sessions_user_started_idx on public.chant_sessions(user_id, started_at desc);
create index if not exists daily_user_counts_date_idx on public.daily_user_counts(date desc, verified_count desc);
create index if not exists group_members_user_idx on public.group_members(user_id);
