import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

enum ButtonType { primary, secondary, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: width,
      height: height ?? 50,
      child: _buildButton(context, theme, isDark),
    );
  }

  Widget _buildButton(BuildContext context, ThemeData theme, bool isDark) {
    switch (type) {
      case ButtonType.primary:
        return _buildPrimaryButton(context, theme, isDark);
      case ButtonType.secondary:
        return _buildSecondaryButton(context, theme, isDark);
      case ButtonType.outlined:
        return _buildOutlinedButton(context, theme, isDark);
      case ButtonType.text:
        return _buildTextButton(context, theme, isDark);
    }
  }

  Widget _buildPrimaryButton(BuildContext context, ThemeData theme, bool isDark) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(25),
        ),
        padding: EdgeInsets.zero,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: onPressed != null && !isLoading
              ? AppTheme.buttonGradient
              : LinearGradient(
            colors: [
              Colors.grey.shade400,
              Colors.grey.shade500,
            ],
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(25),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: _buildButtonContent(Colors.white),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, ThemeData theme, bool isDark) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(25),
        ),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: _buildButtonContent(isDark ? Colors.white : Colors.black87),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, ThemeData theme, bool isDark) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.primaryColor,
        side: BorderSide(
          color: onPressed != null && !isLoading
              ? theme.primaryColor
              : Colors.grey.shade400,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(25),
        ),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: _buildButtonContent(theme.primaryColor),
    );
  }

  Widget _buildTextButton(BuildContext context, ThemeData theme, bool isDark) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: theme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(25),
        ),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: _buildButtonContent(theme.primaryColor),
    );
  }

  Widget _buildButtonContent(Color textColor) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: textColor,
          strokeWidth: 2,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }
}

// Widget factory pour des boutons spécifiques
class WeatherButtons {
  static Widget refreshButton({
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return CustomButton(
      text: 'Actualiser',
      icon: Icons.refresh,
      onPressed: onPressed,
      isLoading: isLoading,
      type: ButtonType.secondary,
      width: 140,
    );
  }

  static Widget locationButton({
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return CustomButton(
      text: 'Ma position',
      icon: Icons.my_location,
      onPressed: onPressed,
      isLoading: isLoading,
      type: ButtonType.outlined,
      width: 150,
    );
  }

  static Widget settingsButton({
    required VoidCallback? onPressed,
  }) {
    return CustomButton(
      text: 'Paramètres',
      icon: Icons.settings,
      onPressed: onPressed,
      type: ButtonType.text,
      width: 120,
    );
  }
}