import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FusedTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final VoidCallback? onTap;

  const FusedTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      focusNode: focusNode,
      validator: validator,
      style: GoogleFonts.inter(
        fontSize: 16,
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: enabled ? colorScheme.surfaceContainerHighest : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        counterText: '',
      ),
    );
  }
}

class FusedCurrencyField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<double?>? onChanged;
  final String currencySymbol;
  final bool enabled;

  const FusedCurrencyField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.currencySymbol = 'GH₵',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Text(
            currencySymbol,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: hint ?? '0.00',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              counterText: '',
            ),
            onChanged: (value) {
              final parsed = double.tryParse(value.replaceAll(',', ''));
              onChanged?.call(parsed);
            },
          ),
        ),
      ],
    );
  }
}