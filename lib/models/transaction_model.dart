enum TransactionSource { manual, smsConfirmed, smsPending }

class TransactionModel {
  final String id;
  final double amount;
  final String type; // 'income' or 'expense'
  final String categoryId; // nullable in DB until user confirms an SMS entry
  final DateTime date;
  final String? note;
  final TransactionSource source;
  final String? rawSmsBody; // kept for reference/debugging if source is SMS-based

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.note,
    this.source = TransactionSource.manual,
    this.rawSmsBody,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'amount': amount,
        'type': type,
        'categoryId': categoryId,
        'date': date.toIso8601String(),
        'note': note,
        'source': source.name,
        'rawSmsBody': rawSmsBody,
      };

  factory TransactionModel.fromMap(Map<String, dynamic> map) => TransactionModel(
        id: map['id'],
        amount: map['amount'],
        type: map['type'],
        categoryId: map['categoryId'],
        date: DateTime.parse(map['date']),
        note: map['note'],
        source: TransactionSource.values.firstWhere(
          (e) => e.name == map['source'],
          orElse: () => TransactionSource.manual,
        ),
        rawSmsBody: map['rawSmsBody'],
      );
}
