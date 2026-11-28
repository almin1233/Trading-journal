# TradeNest

A trading journal that works on phone and desktop.

- Log trades with notes, setup, tags and a rating
- Paste, drop or upload screenshots, then draw on them (pen, arrow, box, text)
- Dashboard with payout readiness, buffer, winning days and the consistency rule
- Optional account: sign in on any device to see the same trades and screenshots
- Backup and restore, CSV export, works offline once opened

## Turn on sign-in and sync (one time, about 5 minutes)

Without this step the app still works, but data stays on one device.

1. Make a free project at https://supabase.com (Dashboard, New project).
2. Open **SQL Editor**, paste all of `supabase-setup.sql`, and press **Run**.
3. Open **Authentication, URL Configuration**. Set **Site URL** to your site address
   (for example `https://YOURNAME.github.io/REPO/`) and add the same address under **Redirect URLs**.
4. Optional: under **Authentication, Sign In / Providers, Email**, turn off **Confirm email**
   if you want people to get in straight after signing up.
5. Open **Project Settings, API Keys**. Copy the **Project URL** and the **anon / publishable** key.
   Never use the `service_role` or secret key.
6. Paste both into `config.js` and commit.

Each person's data is protected by row level security: an account can only read and write its own rows and its own screenshot folder.

Data stored per account: trades, rules, and screenshots (compressed). The free Supabase plan includes 1 GB of file storage.
