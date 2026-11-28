-- TradeNest database setup. Paste this whole file into Supabase > SQL Editor > New query, then press Run.
-- It is safe to run more than once.

create table if not exists public.entries (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id text not null,
  data jsonb not null default '{}'::jsonb,
  updated bigint not null default 0,
  deleted boolean not null default false,
  primary key (user_id, id)
);

create table if not exists public.shots (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id text not null,
  w int not null default 1,
  h int not null default 1,
  marks jsonb not null default '[]'::jsonb,
  updated bigint not null default 0,
  deleted boolean not null default false,
  primary key (user_id, id)
);

create table if not exists public.settings (
  user_id uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated bigint not null default 0
);

alter table public.entries enable row level security;
alter table public.shots enable row level security;
alter table public.settings enable row level security;

drop policy if exists "own entries" on public.entries;
create policy "own entries" on public.entries for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

drop policy if exists "own shots" on public.shots;
create policy "own shots" on public.shots for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

drop policy if exists "own settings" on public.settings;
create policy "own settings" on public.settings for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

-- Private storage bucket for screenshots. Each person can only reach files inside their own folder.
insert into storage.buckets (id, name, public) values ('shots', 'shots', false)
  on conflict (id) do nothing;

drop policy if exists "own shot files read" on storage.objects;
create policy "own shot files read" on storage.objects for select to authenticated
  using (bucket_id = 'shots' and (storage.foldername(name))[1] = (select auth.uid())::text);

drop policy if exists "own shot files insert" on storage.objects;
create policy "own shot files insert" on storage.objects for insert to authenticated
  with check (bucket_id = 'shots' and (storage.foldername(name))[1] = (select auth.uid())::text);

drop policy if exists "own shot files update" on storage.objects;
create policy "own shot files update" on storage.objects for update to authenticated
  using (bucket_id = 'shots' and (storage.foldername(name))[1] = (select auth.uid())::text)
  with check (bucket_id = 'shots' and (storage.foldername(name))[1] = (select auth.uid())::text);

drop policy if exists "own shot files delete" on storage.objects;
create policy "own shot files delete" on storage.objects for delete to authenticated
  using (bucket_id = 'shots' and (storage.foldername(name))[1] = (select auth.uid())::text);
