class CategoryModel {
  final String id;
  final String name;
  final String iconName;
  final int colorValue;
  final String type;
  final double? monthlyCap;
  final bool isDefault;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorValue,
    required this.type,
    this.monthlyCap,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'iconName': iconName,
        'colorValue': colorValue,
        'type': type,
        'monthlyCap': monthlyCap,
        'isDefault': isDefault ? 1 : 0,
      };

  factory CategoryModel.fromMap(Map<String, dynamic> map) => CategoryModel(
        id: map['id'] as String,
        name: map['name'] as String,
        iconName: map['iconName'] as String,
        colorValue: map['colorValue'] as int,
        type: map['type'] as String,
        monthlyCap: (map['monthlyCap'] as num?)?.toDouble(),
        isDefault: (map['isDefault'] as int? ?? 0) == 1,
      );

  CategoryModel copyWith({
    String? id,
    String? name,
    String? iconName,
    int? colorValue,
    String? type,
    double? monthlyCap,
    bool? isDefault,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
      type: type ?? this.type,
      monthlyCap: monthlyCap ?? this.monthlyCap,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class TransactionModel {
  final String id;
  final double amount;
  final String type;
  final String? categoryId;
  final DateTime date;
  final String? note;
  final String source;
  final String? rawSmsBody;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    this.categoryId,
    required this.date,
    this.note,
    required this.source,
    this.rawSmsBody,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'amount': amount,
        'type': type,
        'categoryId': categoryId,
        'date': date.toIso8601String(),
        'note': note,
        'source': source,
        'rawSmsBody': rawSmsBody,
      };

  factory TransactionModel.fromMap(Map<String, dynamic> map) => TransactionModel(
        id: map['id'] as String,
        amount: (map['amount'] as num).toDouble(),
        type: map['type'] as String,
        categoryId: map['categoryId'] as String?,
        date: DateTime.parse(map['date'] as String),
        note: map['note'] as String?,
        source: map['source'] as String,
        rawSmsBody: map['rawSmsBody'] as String?,
      );

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? type,
    String? categoryId,
    DateTime? date,
    String? note,
    String? source,
    String? rawSmsBody,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      note: note ?? this.note,
      source: source ?? this.source,
      rawSmsBody: rawSmsBody ?? this.rawSmsBody,
    );
  }
}

class PendingSmsItem {
  final String id;
  final String senderId;
  final double amount;
  final String type;
  final DateTime smsDate;
  final String rawSmsBody;
  final String? suggestedCategoryId;
  final bool dismissed;

  PendingSmsItem({
    required this.id,
    required this.senderId,
    required this.amount,
    required this.type,
    required this.smsDate,
    required this.rawSmsBody,
    this.suggestedCategoryId,
    this.dismissed = false,
  });

  factory PendingSmsItem.fromMap(Map<String, dynamic> map) => PendingSmsItem(
        id: map['id'] as String,
        senderId: map['senderId'] as String? ?? 'Unknown',
        amount: (map['amount'] as num).toDouble(),
        type: map['type'] as String,
        smsDate: DateTime.parse(map['smsDate'] as String),
        rawSmsBody: map['rawSmsBody'] as String,
        suggestedCategoryId: map['suggestedCategoryId'] as String?,
        dismissed: (map['dismissed'] as int? ?? 0) == 1,
      );
}

class UnrecognizedSmsItem {
  final String id;
  final String senderId;
  final String body;
  final DateTime receivedAt;
  final bool dismissed;

  UnrecognizedSmsItem({
    required this.id,
    required this.senderId,
    required this.body,
    required this.receivedAt,
    this.dismissed = false,
  });

  factory UnrecognizedSmsItem.fromMap(Map<String, dynamic> map) => UnrecognizedSmsItem(
        id: map['id'] as String,
        senderId: map['senderId'] as String,
        body: map['body'] as String,
        receivedAt: DateTime.parse(map['receivedAt'] as String),
        dismissed: (map['dismissed'] as int? ?? 0) == 1,
      );
}