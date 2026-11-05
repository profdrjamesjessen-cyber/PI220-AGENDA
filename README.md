# PI220-AGENDA — Stage 004 / Event Management & Publishing

Stage 004 extends the verified Stage 003 Supabase calendar and administrator authentication with event create, edit, draft/publish, cancel, and delete workflows.

## Included
- Public visitors see published events only.
- Verified administrators can read all events, including drafts and cancelled entries.
- Admin-only create and edit form for title, category, description, start/end, all-day, status, location, and optional public URL.
- Save as `draft`, `published`, or `cancelled`.
- Mark an existing event cancelled without deleting its history.
- Permanent deletion requires a browser confirmation.
- Draft and cancelled events are visually distinguished in the administrator calendar.
- Existing PI220 visual foundation and FullCalendar layout are retained.

## Supabase migration — required before testing Stage 004
Run `supabase/stage004_admin_read_policy.sql` once in the Supabase SQL Editor for the PI220 AGENDA project. It adds an authenticated-admin SELECT policy so administrators can manage drafts and cancelled records. It does not expose the `profiles` table and does not alter the existing public published-only policy or existing write policies.

Expected existing database configuration:
- `public.agenda_events` is exposed through the Data API.
- `public.profiles` remains unexposed.
- RLS is enabled on both tables.
- `public.pi220_is_admin()` returns true only for the signed-in administrator.
- Existing INSERT, UPDATE, and DELETE policies restrict writes to admins.
- Existing grants permit authenticated writes to `agenda_events`.

## Local configuration
`js/supabase-config.js` contains the Supabase project URL and publishable key. The `sb_publishable_` key is intended for browser use. Never add an `sb_secret_` or service-role key to this repository, frontend, or GitHub Pages.

## Test sequence
1. Run the SQL migration above.
2. Run the app through Live Server or deploy to HTTPS.
3. Confirm the public calendar shows published entries and does not show drafts.
4. Sign in with the authorised Supabase administrator account.
5. Confirm the admin-only NEW EVENT control appears.
6. Create a test event with status `draft`; confirm it appears for the admin but not in a signed-out/public session.
7. Change it to `published`; confirm it appears in the public calendar after sign-out or in a separate private browser session.
8. Test editing, marking cancelled, and confirmed deletion using disposable test records.
9. Verify unauthenticated users cannot write directly to the Data API. RLS is the security boundary; frontend visibility is not.

## Important notes
- Status values are lowercase: `draft`, `published`, `cancelled`.
- Category values are uppercase: `LIVE`, `CAM`, `CORP`, `DEV`, `EDU`.
- All timestamps are stored as ISO timestamps (UTC) from the browser's local date/time inputs.
- The UI checks the administrator role before write operations, but database RLS policies must independently enforce the same restriction.
- The audit trigger configured in the earlier schema remains responsible for audit metadata. This app supplies `created_by` and `updated_by` using the authenticated user's UID.
- This build does not yet implement activity-log history, recurring events, external calendar sync, or RADIO/LIVE CAM integration.
