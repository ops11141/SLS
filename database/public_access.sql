-- SLS public access policy: anyone with the site can read, add, and delete reports.
-- Run this in the Supabase SQL Editor for project sxmjyutvnlbifwwymzpw only.
-- WARNING: public DELETE means any visitor can permanently delete any report.
grant select, insert, delete on public.maintenance_reports to anon;

drop policy if exists "Public can read maintenance reports" on public.maintenance_reports;
create policy "Public can read maintenance reports"
on public.maintenance_reports for select to anon using (true);

drop policy if exists "Public can insert maintenance reports" on public.maintenance_reports;
create policy "Public can insert maintenance reports"
on public.maintenance_reports for insert to anon with check (true);

drop policy if exists "Public can delete maintenance reports" on public.maintenance_reports;
create policy "Public can delete maintenance reports"
on public.maintenance_reports for delete to anon using (true);
