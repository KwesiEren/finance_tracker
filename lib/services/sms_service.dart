import 'package:another_telephony/telephony.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../database/database_helper.dart';
import '../models/data_models.dart';
import '../models/sms_template_model.dart';
import 'sms_refresh.dart';
import 'sms_sender_normalizer.dart';
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
  static bool _isListening = false;
  static const _serviceChannel = MethodChannel('com.fused/service');
  static const _smsChannel = MethodChannel('com.fused/sms');
  static bool _nativeChannelSetup = false;

  Future<bool> requestPermissions() async {
    final granted = await _telephony.requestPhoneAndSmsPermissions;
    return granted ?? false;
  }

  void startListening() {
    if (_isListening) return;
    _isListening = true;
    _telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) => _handleIncoming(message),
      listenInBackground: false,
    );
    setupNativeChannel();
  }

  void setupNativeChannel() {
    if (_nativeChannelSetup) return;
    _nativeChannelSetup = true;
    _smsChannel.setMethodCallHandler((call) async {
      if (call.method == 'onSmsReceived') {
        final args = call.arguments as Map?;
        final sender = args?['sender'] as String? ?? 'Unknown';
        final body = args?['body'] as String? ?? '';
        final ts = args?['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch;
        final date = DateTime.fromMillisecondsSinceEpoch(ts);
        await _handleNative(sender, body, date);
      }
    });
  }

  Future<void> _handleNative(String sender, String body, DateTime date) async {
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
        'smsDate': date.toIso8601String(),
        'rawSmsBody': body,
        'suggestedCategoryId': null,
        'dismissed': 0,
      });
      bumpSmsRefresh();
      return;
    }
    if (SmsTemplateMatcher.looksFinancial(body)) {
      await _db.insertUnrecognized({
        'id': _uuid.v4(),
        'senderId': sender,
        'body': body,
        'receivedAt': date.toIso8601String(),
        'dismissed': 0,
      });
      bumpSmsRefresh();
    }
  }

  Future<void> startForeground() async {
    try {
      await _serviceChannel.invokeMethod('startForeground');
    } catch (_) {}
  }

  Future<void> stopForeground() async {
    try {
      await _serviceChannel.invokeMethod('stopForeground');
    } catch (_) {}
  }

  /// Scan existing inbox for missed messages (used by WorkManager polling + resume fallback).
  Future<void> scanInbox({int lookbackDays = 30}) async {
    try {
      final messages = await _telephony.getInboxSms(
        columns: [SmsColumn.BODY, SmsColumn.DATE, SmsColumn.ADDRESS],
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );
      final cutoff = DateTime.now().subtract(Duration(days: lookbackDays));
      for (final msg in messages) {
        final millis = int.tryParse(msg.date?.toString() ?? '0') ?? 0;
        final date = millis > 0 ? DateTime.fromMillisecondsSinceEpoch(millis) : DateTime.now();
        if (date.isBefore(cutoff)) continue;
        await _handleIncoming(msg);
      }
    } catch (_) {
      // Permission denied or Telephony unavailable (e.g., WorkManager isolate without grant)
      return;
    }
  }

  Future<void> _handleIncoming(SmsMessage message) async {
    final body = message.body ?? '';
    final sender = message.address ?? 'Unknown';
    if (body.isEmpty) return;
    final millis = int.tryParse(message.date?.toString() ?? '0') ?? 0;
    final smsDate = millis > 0 ? DateTime.fromMillisecondsSinceEpoch(millis) : DateTime.now();
    await _handleNative(sender, body, smsDate);
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
    bumpSmsRefresh();
  }

  Future<void> dismissPendingSms(String id) async {
    await _db.dismissPendingSms(id);
    bumpSmsRefresh();
  }

  Future<void> insertUnrecognized(Map<String, dynamic> row) async {
    await _db.insertUnrecognized(row);
    bumpSmsRefresh();
  }

  Future<List<SmsTemplateModel>> getTemplatesForSender(String sender) async {
    final all = await _db.getTemplates();
    final norm = normalizeSender(sender);
    return all.where((t) => normalizeSender(t.senderId) == norm).toList();
  }
}
