import 'package:flutter/material.dart';
import '../models/category_model.dart';

class BudgetProgressBar extends StatelessWidget {
  final CategoryModel category;
  final double spent;
  final String currency;

  const BudgetProgressBar({
    super.key,
    required this.category,
    required this.spent,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final cap = category.monthlyCap;
    final hasCap = cap != null && cap > 0;
    final ratio = hasCap ? (spent / cap).clamp(0.0, 1.0) : 0.0;

    Color barColor = Color(category.colorValue);
    if (hasCap) {
      if (spent >= cap) {
        barColor = Colors.red;
      } else if (spent / cap >= 0.8) {
        barColor = Colors.orange;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                hasCap
                    ? '$currency ${spent.toStringAsFixed(0)} / ${cap.toStringAsFixed(0)}'
                    : '$currency ${spent.toStringAsFixed(0)} (no cap set)',
                style: TextStyle(color: hasCap && spent >= cap ? Colors.red : null),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (hasCap)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation(barColor),
              ),
            ),
        ],
      ),
    );
  }
}
