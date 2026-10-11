-- SLS Maintenance Reports: independent Supabase schema
-- Run this in the SQL Editor of a NEW Supabase project created for ops11141/sls.
-- Do not run it in the existing mn project.

create extension if not exists pgcrypto;

create table if not exists public.maintenance_reports (
  id uuid primary key default gen_random_uuid(),
  report_type text not null check (report_type in ('shift','scheduled','outage3','outage6')),
  report_date date not null,
  report_day text,
  summary text not null,
  office text,
  department text,
  author text,
  report_data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists maintenance_reports_date_idx
  on public.maintenance_reports (report_date desc);
create index if not exists maintenance_reports_type_date_idx
  on public.maintenance_reports (report_type, report_date desc);
create index if not exists maintenance_reports_office_idx
  on public.maintenance_reports (office);

create or replace function public.set_maintenance_reports_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists maintenance_reports_updated_at on public.maintenance_reports;
create trigger maintenance_reports_updated_at
before update on public.maintenance_reports
for each row execute function public.set_maintenance_reports_updated_at();

alter table public.maintenance_reports enable row level security;

-- Secure defaults: only authenticated users can access records.
drop policy if exists "Authenticated users can read maintenance reports" on public.maintenance_reports;
create policy "Authenticated users can read maintenance reports"
on public.maintenance_reports for select to authenticated using (true);

drop policy if exists "Authenticated users can insert maintenance reports" on public.maintenance_reports;
create policy "Authenticated users can insert maintenance reports"
on public.maintenance_reports for insert to authenticated with check (true);

drop policy if exists "Authenticated users can update maintenance reports" on public.maintenance_reports;
create policy "Authenticated users can update maintenance reports"
on public.maintenance_reports for update to authenticated using (true) with check (true);

drop policy if exists "Authenticated users can delete maintenance reports" on public.maintenance_reports;
create policy "Authenticated users can delete maintenance reports"
on public.maintenance_reports for delete to authenticated using (true);

grant select, insert, update, delete on public.maintenance_reports to authenticated;
