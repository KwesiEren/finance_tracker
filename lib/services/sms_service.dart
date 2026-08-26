import 'package:another_telephony/telephony.dart';
import 'package:uuid/uuid.dart';
import '../database/database_helper.dart';
import '../models/data_models.dart';
import '../models/sms_template_model.dart';
import 'sms_template_matcher.dart';

/// Reads incoming SMS (Android only) and matches them against the user's
/// own taught templates (see teach_sms_screen.dart + sms_template_matcher.dart)
/// instead of hardcoded per-bank regex.
///
/// Flow for every incoming message:
///  1. Try to match it against a saved template for that sender.
///     - Match found -> insert a pending transaction (still requires the
///       user to confirm + pick a category, same as before).
///  2. No match, but it looks financial (soft heuristic) ->
///     drop it in "unrecognized_sms" so the user can teach a new template
///     from it later, without hunting through their whole inbox.
///  3. No match, doesn't look financial -> ignored entirely.
class SmsService {
  final Telephony _telephony = Telephony.instance;
  final _uuid = const Uuid();
  final _db = DatabaseHelper.instance;

  Future<bool> requestPermissions() async {
    final granted = await _telephony.requestPhoneAndSmsPermissions;
    return granted ?? false;
  }

  void startListening() {
    _telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) => _handleIncoming(message),
      listenInBackground: false,
    );
  }

  /// Optional: scan existing inbox on first setup so historical messages
  /// aren't missed, and so the "teach" screen has real examples to show
  /// right after onboarding instead of starting empty.
  Future<void> scanInbox({int lookbackDays = 30}) async {
    final messages = await _telephony.getInboxSms(
      columns: [SmsColumn.BODY, SmsColumn.DATE, SmsColumn.ADDRESS],
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
    );
    final cutoff = DateTime.now().subtract(Duration(days: lookbackDays));
    for (final msg in messages) {
      final date = DateTime.fromMillisecondsSinceEpoch(int.tryParse(msg.date as String? ?? '0') ?? 0);
      if (date.isBefore(cutoff)) continue;
      await _handleIncoming(msg);
    }
  }

  Future<void> _handleIncoming(SmsMessage message) async {
    final body = message.body ?? '';
    final sender = message.address ?? 'Unknown';
    if (body.isEmpty) return;

    final templates = await _db.getTemplates();
    final amount = SmsTemplateMatcher.match(sender, body, templates);

    if (amount != null) {
      final direction = SmsTemplateMatcher.matchDirection(sender, body, templates) ?? 'expense';
      await _db.insertPendingSms({
        'id': _uuid.v4(),
        'senderId': sender,
        'amount': amount,
        'type': direction,
        'smsDate': DateTime.now().toIso8601String(),
        'rawSmsBody': body,
        'suggestedCategoryId': null,
        'dismissed': 0,
      });
      return;
    }

    // No template matched — queue it for teaching only if it's plausibly
    // a financial message, so the teach screen doesn't fill up with noise.
    if (SmsTemplateMatcher.looksFinancial(body)) {
      await _db.insertUnrecognized({
        'id': _uuid.v4(),
        'senderId': sender,
        'body': body,
        'receivedAt': DateTime.now().toIso8601String(),
        'dismissed': 0,
      });
    }
  }

  Future<List<PendingSmsItem>> getPendingSmsItems() async {
    final rows = await _db.getPendingSms();
    return rows.map((r) => PendingSmsItem.fromMap(r)).toList();
  }

  Future<int> getPendingSmsCount() async {
    final items = await getPendingSmsItems();
    return items.length;
  }

  /// Returns recent inbox messages filtered to financial-looking only (for picker)
  Future<List<SmsMessage>> getInboxForPicker({int limit = 100}) async {
    try {
      final msgs = await _telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );
      final out = <SmsMessage>[];
      for (final m in msgs) {
        if (m.body == null || m.body!.isEmpty) continue;
        if (!SmsTemplateMatcher.looksFinancial(m.body!)) continue;
        out.add(m);
        if (out.length >= limit) break;
      }
      return out;
    } catch (_) {
      return [];
    }
  }

  Future<List<UnrecognizedSmsItem>> getUnrecognizedItems() async {
    final rows = await _db.getUnrecognized();
    return rows.map((r) => UnrecognizedSmsItem.fromMap(r)).toList();
  }

  Future<void> dismissUnrecognized(String id) async {
    await _db.dismissUnrecognized(id);
  }

  Future<void> dismissPendingSms(String id) async {
    await _db.dismissPendingSms(id);
  }

  Future<void> insertUnrecognized(Map<String, dynamic> row) async {
    await _db.insertUnrecognized(row);
  }

  Future<List<SmsTemplateModel>> getTemplatesForSender(String sender) async {
    final all = await _db.getTemplates();
    return all.where((t) => t.senderId == sender).toList();
  }
}
