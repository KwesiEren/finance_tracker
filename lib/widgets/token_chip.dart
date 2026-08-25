import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TokenChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Color? color;
  final IconData? icon;

  const TokenChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.onDelete,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final chipColor = color ?? colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: onDelete != null ? 12 : 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected ? chipColor : chipColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? chipColor : chipColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? colorScheme.onPrimary : chipColor,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? colorScheme.onPrimary : chipColor,
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 8),
              InkWell(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: selected ? colorScheme.onPrimary : chipColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class TokenChipGroup extends StatelessWidget {
  final List<String> tokens;
  final Set<String> selectedTokens;
  final ValueChanged<String> onTokenToggled;
  final Color? color;
  final bool multiSelect;

  const TokenChipGroup({
    super.key,
    required this.tokens,
    required this.selectedTokens,
    required this.onTokenToggled,
    this.color,
    this.multiSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tokens.map((token) {
        final isSelected = selectedTokens.contains(token);
        return TokenChip(
          label: token,
          selected: isSelected,
          color: color,
          onTap: () => onTokenToggled(token),
        );
      }).toList(),
    );
  }
}

class TokenChipDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<String> beforeTokens;
  final List<String> afterTokens;
  final Set<String> selectedBefore;
  final Set<String> selectedAfter;
  final ValueChanged<String> onBeforeToggled;
  final ValueChanged<String> onAfterToggled;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const TokenChipDialog({
    super.key,
    required this.title,
    required this.message,
    required this.beforeTokens,
    required this.afterTokens,
    required this.selectedBefore,
    required this.selectedAfter,
    required this.onBeforeToggled,
    required this.onAfterToggled,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: GoogleFonts.inter(fontSize: 14, color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 20),
            Text('BEFORE amount', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.primary)),
            const SizedBox(height: 8),
            TokenChipGroup(
              tokens: beforeTokens,
              selectedTokens: selectedBefore,
              onTokenToggled: onBeforeToggled,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text('AFTER amount', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.tertiary)),
            const SizedBox(height: 8),
            TokenChipGroup(
              tokens: afterTokens,
              selectedTokens: selectedAfter,
              onTokenToggled: onAfterToggled,
              color: colorScheme.tertiary,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: onCancel, child: Text('Cancel', style: GoogleFonts.inter())),
        FilledButton(onPressed: onConfirm, child: Text('Create Template', style: GoogleFonts.inter())),
      ],
    );
  }
}