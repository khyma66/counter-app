create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.mantras (
  id text primary key,
  name text not null,
  language_code text not null default 'sa',
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

insert into public.mantras (id, name) values
  ('om-namah-shivaya', 'Om Namah Shivaya'),
  ('hare-krishna', 'Hare Krishna Maha Mantra'),
  ('om-namo-narayanaya', 'Om Namo Narayanaya')
on conflict (id) do update set name = excluded.name;

create table if not exists public.chant_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  mantra_id text not null references public.mantras(id),
  started_at timestamptz not null,
  ended_at timestamptz,
  chant_count integer not null check (chant_count >= 0),
  duration_seconds integer not null default 0 check (duration_seconds >= 0),
  source text not null default 'mock' check (source in ('manual', 'mock', 'voice')),
  client_created_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (ended_at is null or ended_at >= started_at),
  check (chant_count <= 1000000)
);

create index if not exists chant_sessions_user_started_idx
  on public.chant_sessions (user_id, started_at desc);
create index if not exists chant_sessions_mantra_started_idx
  on public.chant_sessions (mantra_id, started_at desc);

create or replace view public.leaderboard_totals
with (security_invoker = true)
as
select user_id, sum(chant_count)::bigint as total_count
from public.chant_sessions
group by user_id;

grant usage on schema public to anon, authenticated;
grant select on public.mantras to anon, authenticated;
grant select, insert, update, delete on public.profiles to authenticated;
grant select, insert, update, delete on public.chant_sessions to authenticated;
grant select on public.leaderboard_totals to authenticated;

alter table public.profiles enable row level security;
alter table public.mantras enable row level security;
alter table public.chant_sessions enable row level security;

create policy "mantras are readable"
on public.mantras for select
using (true);

create policy "users read own profile"
on public.profiles for select
using (auth.uid() = id);
create policy "users insert own profile"
on public.profiles for insert
with check (auth.uid() = id);
create policy "users update own profile"
on public.profiles for update
using (auth.uid() = id)
with check (auth.uid() = id);

create policy "users read own sessions"
on public.chant_sessions for select
using (auth.uid() = user_id);
create policy "users insert own sessions"
on public.chant_sessions for insert
with check (auth.uid() = user_id);
create policy "users update own sessions"
on public.chant_sessions for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
create policy "users delete own sessions"
on public.chant_sessions for delete
using (auth.uid() = user_id);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id) values (new.id)
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();
