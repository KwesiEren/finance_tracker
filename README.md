# Finance Tracker (Flutter)

A personal income/expense/budget tracker that:
- Lets the user fully define their own categories (no hardcoded list)
- Optionally reads SMS (Android only) to detect bank/MoMo debit & credit alerts —
  **by learning from examples the user tags, not hardcoded regex per bank**
- Never auto-logs SMS silently — every detected transaction is reviewed and
  assigned a category by the user before it counts toward a budget
- Alerts when a category nears (default 80%) or exceeds its monthly cap
- Sends a daily or monthly spending report, user's choice

## Why "teach by example" instead of hardcoded bank regex

Earlier versions of this design used hand-written regex per bank/MoMo
provider. That breaks down fast in practice: providers change wording
without notice, coverage is only as good as whichever formats you happened
to test against, and it needs ongoing maintenance forever.

Instead, the user teaches the app directly: they tap the amount in a real
message they received, mark whether it was money in or out, and the app
builds a reusable template from the sender ID + surrounding wording. Every
future message from that sender with similar phrasing gets matched
automatically. This means:
- Works for **any** provider, including ones added after this code was written
- No false positives from OTPs/promos — the app only recognizes what it's
  been shown
- No central regex list to maintain
- Each user's templates match their own actual banks/providers, nothing more

## Getting started

```bash
flutter pub get
flutter run
```

## Android setup (required for SMS detection)

Add these permissions to `android/app/src/main/AndroidManifest.xml`, inside `<manifest>`:

```xml
<uses-permission android:name="android.permission.RECEIVE_SMS"/>
<uses-permission android:name="android.permission.READ_SMS"/>
```

SMS reading is **Android-only** — iOS does not permit programmatic access to
SMS content under any circumstance. On iOS, the app works fully for manual
entry, budgets, caps, and reports; the "Detected" tab will simply stay empty.

## Project structure

```
lib/
  models/          Category, Transaction, Settings — plain data classes
  database/         SQLite schema + queries (sqflite)
  services/
    sms_service.dart           Listens for incoming SMS, matches against templates
    sms_template_matcher.dart  Builds templates from tagged examples + matches new SMS
    notification_service.dart  Local notifications (cap alerts, reports)
    report_service.dart        Builds summaries, schedules background delivery
  providers/         Riverpod state — connects DB to UI, runs budget checks
  screens/
    dashboard_screen.dart      This month's income/spend + budget bars
    add_transaction_screen.dart Manual entry
    pending_sms_screen.dart     Review/confirm SMS-detected transactions
    teach_sms_screen.dart       Tag a real message to teach a new pattern
    manage_templates_screen.dart View/delete learned patterns
    reports_screen.dart         Pie chart + daily/monthly report toggle
    categories_screen.dart      Create/edit/delete categories & caps
  widgets/
    budget_progress_bar.dart   Color-coded progress bar (green/orange/red)
  main.dart          App entry point, bottom nav shell
```

## How the pieces connect

1. **Categories are just rows in SQLite** — nothing is hardcoded beyond a
   few starter suggestions inserted on first launch (Transport, Airtime,
   Food, Utilities, Debt Repayment, Salary). The user can rename, delete,
   recolor, or add categories freely from the Categories tab.

2. **SMS flow**: `sms_service.dart` listens for incoming messages and checks
   each one against the user's saved templates (`sms_templates` table) via
   `sms_template_matcher.dart`.
   - **Match found** → inserted into `pending_sms`. The "Detected" tab shows
     these; the user picks a category and confirms, which is when it becomes
     a real transaction and can trigger a budget check. SMS never writes to
     `transactions` directly.
   - **No match, but looks financial** (soft keyword+number heuristic, see
     `looksFinancial()`) → queued in `unrecognized_sms` for the **Teach**
     tab.
   - **No match, doesn't look financial** → ignored entirely.

3. **Teaching a new pattern** (`teach_sms_screen.dart`): the user opens a
   message from the Teach tab, taps the token that is the amount, marks
   money in/out, and saves. `SmsTemplateMatcher.buildTemplate()` captures
   the sender ID plus a few words before/after the tapped amount as the
   template's "shape". Future messages from that sender matching that shape
   get the amount extracted automatically. Saved templates are viewable and
   deletable from **Learned Patterns** (linked from the Teach tab's app bar).

3. **Budget checks** happen in `TransactionsNotifier._checkBudget()` — every
   time a new expense is added (manual or SMS-confirmed), it re-sums that
   category's spend for the month and compares it to the cap. Crossing 80%
   (configurable via `SettingsModel.capAlertThreshold`) or 100% fires a
   local notification.

4. **Reports**: the user picks daily or monthly in the Reports tab. This
   schedules a `workmanager` background task that calls
   `ReportService.deliverNow()`, which sums income/expense/category totals
   for the relevant period and pushes a notification. There's also a
   "Send report now" button for an on-demand check.

## Improving match accuracy

Because templates come from real user-tagged messages, accuracy improves
per-user automatically — no code changes needed as new formats appear.
Two things worth tuning as you test with real inboxes:
- `beforeCount`/`afterCount` in `SmsTemplateMatcher.buildTemplate()` (how
  many words of context to capture) — too few risks false matches, too many
  makes templates brittle to minor wording changes (e.g. an added comma).
- `looksFinancial()` in `sms_template_matcher.dart` — the soft heuristic
  deciding what's worth showing in the Teach queue. Loosen it if real
  transaction messages aren't showing up there; tighten it if too much
  noise (OTPs, promos) is appearing.

## What's intentionally left for you to build next

- Editing/deleting individual transactions from the dashboard
- Export (CSV/PDF) of transaction history
- Multi-currency support beyond a single symbol setting
- Matching SMS merchant names to auto-suggest a category instead of leaving
  the dropdown blank
- An onboarding step that runs `SmsService.scanInbox()` once on first launch
  and routes straight into the Teach flow, so new users have real examples
  to tag immediately instead of waiting for their next transaction
- App-level PIN/biometric lock — not yet implemented, worth prioritizing
  before any real deployment since this holds financial data
