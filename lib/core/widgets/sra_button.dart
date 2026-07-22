import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

class SraButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isOutlined;

  const SraButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;
    final bg = backgroundColor ?? AppColors.champagneGold;
    final fg = foregroundColor ?? (isOutlined ? AppColors.champagneGold : Colors.white);
    
    final labelWidget = Text(
      label.toUpperCase(),
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 11,
        letterSpacing: 1.6,
        color: fg.withValues(alpha: isDisabled ? 0.6 : 1.0),
      ),
    );

    final double verticalPadding = icon != null ? 14 : 16;

    if (isOutlined) {
      final outlinedStyle = OutlinedButton.styleFrom(
        side: BorderSide(
          color: bg.withValues(alpha: isDisabled ? 0.3 : 0.8),
          width: 1.2,
        ),
        padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
      );

      if (icon != null) {
        return OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 16, color: fg.withValues(alpha: isDisabled ? 0.5 : 1.0)),
          label: labelWidget,
          style: outlinedStyle,
        );
      }

      return OutlinedButton(
        onPressed: onPressed,
        style: outlinedStyle,
        child: labelWidget,
      );
    }

    final isCustomBg = backgroundColor != null;
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      gradient: isCustomBg
          ? null
          : AppColors.goldGradient,
      color: isCustomBg ? bg : null,
      boxShadow: isCustomBg
          ? null
          : [isDisabled ? AppShadows.shadowGoldDisabled : AppShadows.shadowGold],
    );

    return Opacity(
      opacity: isDisabled ? 0.6 : 1.0,
      child: Container(
        decoration: decoration,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: fg,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
          ),
          child: icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 16, color: fg),
                    const SizedBox(width: 8),
                    labelWidget,
                  ],
                )
              : labelWidget,
        ),
      ),
    );
  }
}

