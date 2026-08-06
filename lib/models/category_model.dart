/// A user-defined spending/income category.
/// Nothing is hardcoded — the user creates, renames, colors,
/// and caps every category themselves. Starter categories are
/// only suggestions inserted on first launch (see database_helper.dart).
class CategoryModel {
  final String id;
  final String name;
  final String iconName; // maps to an IconData in the UI layer
  final int colorValue; // stored as Color.value (int)
  final String type; // 'income' or 'expense'
  final double? monthlyCap; // null = no cap set for this category
  final bool isDefault; // true for starter categories, still editable/deletable

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
        id: map['id'],
        name: map['name'],
        iconName: map['iconName'],
        colorValue: map['colorValue'],
        type: map['type'],
        monthlyCap: map['monthlyCap'],
        isDefault: map['isDefault'] == 1,
      );

  CategoryModel copyWith({
    String? name,
    String? iconName,
    int? colorValue,
    double? monthlyCap,
  }) =>
      CategoryModel(
        id: id,
        name: name ?? this.name,
        iconName: iconName ?? this.iconName,
        colorValue: colorValue ?? this.colorValue,
        type: type,
        monthlyCap: monthlyCap ?? this.monthlyCap,
        isDefault: isDefault,
      );
}
