import 'dart:async';

/// Broadcast stream bumping whenever pending/unrecognized SMS tables change.
/// Providers watch this to refresh instantly without manual invalidate.
final StreamController<void> smsRefreshController = StreamController<void>.broadcast();

void bumpSmsRefresh() {
  if (!smsRefreshController.isClosed) smsRefreshController.add(null);
}
