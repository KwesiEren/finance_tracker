/// A pattern the user taught the app by tagging a real message they received.
/// Instead of a hardcoded regex per bank, each template is built from one
/// example: which sender it came from, the few words immediately before and
/// after the amount, and whether that sender's message meant money in or out.
class SmsTemplateModel {
  final String id;
  final String senderId; // e.g. "MTNMoMo", "GCB-Bank", or a phone number
  final String before; // 1-4 words immediately before the amount in the sample
  final String after; // 1-4 words immediately after the amount in the sample
  final String direction; // 'income' or 'expense' — user-tagged, not guessed
  final String sampleBody; // kept for reference / re-teaching later
  final DateTime createdAt;

  SmsTemplateModel({
    required this.id,
    required this.senderId,
    required this.before,
    required this.after,
    required this.direction,
    required this.sampleBody,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'senderId': senderId,
        'before': before,
        'after': after,
        'direction': direction,
        'sampleBody': sampleBody,
        'createdAt': createdAt.toIso8601String(),
      };

  factory SmsTemplateModel.fromMap(Map<String, dynamic> map) => SmsTemplateModel(
        id: map['id'],
        senderId: map['senderId'],
        before: map['before'],
        after: map['after'],
        direction: map['direction'],
        sampleBody: map['sampleBody'],
        createdAt: DateTime.parse(map['createdAt']),
      );
}
