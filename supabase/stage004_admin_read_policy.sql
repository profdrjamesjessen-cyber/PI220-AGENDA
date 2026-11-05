-- PI220-AGENDA Stage 004
-- Allow verified administrators to read all agenda rows, including drafts and cancelled events.
-- Public/anonymous users continue to read published rows only.
-- Existing INSERT/UPDATE/DELETE admin policies remain in force.

begin;

drop policy if exists "Admins read all events" on public.agenda_events;
create policy "Admins read all events"
on public.agenda_events
for select
to authenticated
using (public.pi220_is_admin());

commit;
