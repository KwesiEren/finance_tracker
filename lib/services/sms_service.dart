import 'package:another_telephony/telephony.dart';
import 'package:uuid/uuid.dart';
import '../database/database_helper.dart';

/// Reads incoming SMS (Android only — iOS does not allow programmatic SMS
/// access) and parses bank/mobile-money debit/credit alerts into pending
/// transactions the user reviews and confirms. Nothing is auto-logged
/// silently: this reduces the risk of a bad regex match creating a wrong
/// entry the user never notices.
class SmsService {
  final Telephony _telephony = Telephony.instance;
  final _uuid = const Uuid();
  final _db = DatabaseHelper.instance;

  /// Common Ghanaian bank / MoMo alert phrasing. Extend this list as you
  /// discover new formats — providers change wording occasionally, so this
  /// should be treated as a living config, not a finished list.
  static final List<RegExp> _patterns = [
    // e.g. "You have been debited GHS 20.00 for..."
    RegExp(r'debited.*?(?:GHS|GH₵)\s?([\d,]+\.?\d*)', caseSensitive: false),
    // e.g. "You have received GHS 50.00 from..."
    RegExp(r'(?:received|credited).*?(?:GHS|GH₵)\s?([\d,]+\.?\d*)', caseSensitive: false),
  ];

  Future<bool> requestPermissions() async {
    final granted = await _telephony.requestPhoneAndSmsPermissions;
    return granted ?? false;
  }

  /// Call once at app startup (after permission granted) to start listening
  /// for new incoming messages in real time.
  void startListening() {
    _telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) => _handleIncoming(message),
      listenInBackground: false,
    );
  }

  /// Optional: scan existing inbox on first setup so historical transactions
  /// aren't missed (e.g. last 30 days).
  Future<void> scanInbox({int lookbackDays = 30}) async {
    final messages = await _telephony.getInboxSms(
      columns: [SmsColumn.BODY, SmsColumn.DATE, SmsColumn.ADDRESS],
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
    );
    final cutoff = DateTime.now().subtract(Duration(days: lookbackDays));
    for (final msg in messages) {
      final date = DateTime.fromMillisecondsSinceEpoch(int.tryParse(msg.date ?? '0') ?? 0);
      if (date.isBefore(cutoff)) continue;
      await _handleIncoming(msg);
    }
  }

  Future<void> _handleIncoming(SmsMessage message) async {
    final body = message.body ?? '';
    final parsed = _parse(body);
    if (parsed == null) return; // not a financial SMS — ignore

    await _db.insertPendingSms({
      'id': _uuid.v4(),
      'amount': parsed.amount,
      'type': parsed.type,
      'smsDate': DateTime.now().toIso8601String(),
      'rawSmsBody': body,
      'suggestedCategoryId': null, // matched against past confirmations in the UI layer
      'dismissed': 0,
    });
  }

  _ParsedSms? _parse(String body) {
    // Debit = expense
    final debitMatch = _patterns[0].firstMatch(body);
    if (debitMatch != null) {
      final amount = double.tryParse(debitMatch.group(1)!.replaceAll(',', ''));
      if (amount != null) return _ParsedSms(amount: amount, type: 'expense');
    }
    // Credit = income
    final creditMatch = _patterns[1].firstMatch(body);
    if (creditMatch != null) {
      final amount = double.tryParse(creditMatch.group(1)!.replaceAll(',', ''));
      if (amount != null) return _ParsedSms(amount: amount, type: 'income');
    }
    return null;
  }
}

class _ParsedSms {
  final double amount;
  final String type;
  _ParsedSms({required this.amount, required this.type});
}
