# Finance Tracker (Flutter)

A personal income/expense/budget tracker that:
- Lets the user fully define their own categories (no hardcoded list)
- Optionally reads SMS (Android only) to detect bank/MoMo debit & credit alerts
- Never auto-logs SMS silently — every detected transaction is reviewed and
  assigned a category by the user before it counts toward a budget
- Alerts when a category nears (default 80%) or exceeds its monthly cap
- Sends a daily or monthly spending report, user's choice

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
    sms_service.dart          Listens for + parses incoming SMS
    notification_service.dart  Local notifications (cap alerts, reports)
    report_service.dart        Builds summaries, schedules background delivery
  providers/         Riverpod state — connects DB to UI, runs budget checks
  screens/
    dashboard_screen.dart      This month's income/spend + budget bars
    add_transaction_screen.dart Manual entry
    pending_sms_screen.dart     Review/confirm SMS-detected transactions
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

2. **SMS flow**: `sms_service.dart` listens for incoming messages, runs them
   through regex patterns matching common bank/MoMo debit/credit phrasing,
   and inserts a row into `pending_sms`. It does **not** touch the main
   `transactions` table directly. The "Detected" tab shows these pending
   entries; the user picks a category and taps confirm, which is when it
   becomes a real transaction and can trigger a budget check.

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

## Extending the SMS parser

Bank and mobile money alert formats vary and change over time. The regex
patterns live in `sms_service.dart` under `_patterns` — add new patterns
there as you encounter message formats that aren't being caught. Treat this
as a living list, not a finished one.

## What's intentionally left for you to build next

- Editing/deleting individual transactions from the dashboard
- Export (CSV/PDF) of transaction history
- Multi-currency support beyond a single symbol setting
- Matching SMS merchant names to auto-suggest a category instead of leaving
  the dropdown blank
