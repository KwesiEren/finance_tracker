import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum FusedButtonVariant { primary, secondary, outline, ghost, destructive }
enum FusedButtonSize { small, medium, large }

class FusedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final FusedButtonVariant variant;
  final FusedButtonSize size;
  final bool fullWidth;
  final bool loading;
  final bool disabled;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const FusedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = FusedButtonVariant.primary,
    this.size = FusedButtonSize.medium,
    this.fullWidth = false,
    this.loading = false,
    this.disabled = false,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDisabled = disabled || loading || onPressed == null;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? borderSide;

    switch (variant) {
      case FusedButtonVariant.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        borderSide = BorderSide.none;
        break;
      case FusedButtonVariant.secondary:
        backgroundColor = colorScheme.secondary;
        foregroundColor = colorScheme.onSecondary;
        borderSide = BorderSide.none;
        break;
      case FusedButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        borderSide = BorderSide(color: colorScheme.outline, width: 1.5);
        break;
      case FusedButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        borderSide = BorderSide.none;
        break;
      case FusedButtonVariant.destructive:
        backgroundColor = colorScheme.error;
        foregroundColor = colorScheme.onError;
        borderSide = BorderSide.none;
        break;
    }

    final horizontalPadding = switch (size) {
      FusedButtonSize.small => 16.0,
      FusedButtonSize.medium => 24.0,
      FusedButtonSize.large => 32.0,
    };
    final verticalPadding = switch (size) {
      FusedButtonSize.small => 8.0,
      FusedButtonSize.medium => 12.0,
      FusedButtonSize.large => 16.0,
    };
    final borderRadius = switch (size) {
      FusedButtonSize.small => 8.0,
      FusedButtonSize.medium => 12.0,
      FusedButtonSize.large => 16.0,
    };
    final fontSize = switch (size) {
      FusedButtonSize.small => 13.0,
      FusedButtonSize.medium => 14.0,
      FusedButtonSize.large => 16.0,
    };

    final button = FilledButton(
      onPressed: isDisabled ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: borderSide ?? BorderSide.none,
        ),
        minimumSize: Size(fullWidth ? double.infinity : 0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return foregroundColor.withValues(alpha: 0.12);
            }
            if (states.contains(WidgetState.hovered)) {
              return foregroundColor.withValues(alpha: 0.08);
            }
            return null;
          },
        ),
      ),
      child: loading
          ? SizedBox(
              width: fontSize + 4,
              height: fontSize + 4,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(foregroundColor),
              ),
            )
          : Row(
              mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null) ...[
                  leadingIcon!,
                  SizedBox(width: fontSize * 0.5),
                ],
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                if (trailingIcon != null) ...[
                  SizedBox(width: fontSize * 0.5),
                  trailingIcon!,
                ],
              ],
            ),
    );

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: button,
    );
  }
}