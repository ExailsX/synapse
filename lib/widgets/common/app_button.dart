import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonStyle? style;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final double borderRadius;
  final double elevation;
  final double hoverElevation;
  final double focusElevation;
  final double disabledElevation;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final MaterialTapTargetSize? tapTargetSize;
  final Duration animationDuration;
  final MouseCursor? enabledMouseCursor;
  final MouseCursor? disabledMouseCursor;
  final VisualDensity? visualDensity;
  final WidgetStateProperty<Color?>? overlayColor;
  final WidgetStateProperty<Color?>? shadowColor;
  final WidgetStateProperty<double>? elevationProperty;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ButtonType buttonType;

  const AppButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.style,
    this.width,
    this.height = 48,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.borderRadius = 12,
    this.elevation = 0,
    this.hoverElevation = 2,
    this.focusElevation = 2,
    this.disabledElevation = 0,
    this.side,
    this.shape,
    this.tapTargetSize,
    this.animationDuration = const Duration(milliseconds: 150),
    this.enabledMouseCursor,
    this.disabledMouseCursor,
    this.visualDensity,
    this.overlayColor,
    this.shadowColor,
    this.elevationProperty,
    this.onHover,
    this.onFocusChange,
    this.buttonType = ButtonType.elevated,
    required this.child,
  });

  factory AppButton.primary({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
    double? height = 48,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? foregroundColor,
    double borderRadius = 12,
    double elevation = 0,
    MaterialTapTargetSize? tapTargetSize,
  }) {
    return AppButton(
      key: key,
      child: child,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
      height: height,
      padding: padding,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderRadius: borderRadius,
      elevation: elevation,
      tapTargetSize: tapTargetSize,
      buttonType: ButtonType.elevated,
    );
  }

  factory AppButton.secondary({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
    double? height = 48,
    EdgeInsetsGeometry? padding,
    Color? foregroundColor,
    double borderRadius = 12,
    double elevation = 0,
    MaterialTapTargetSize? tapTargetSize,
  }) {
    return AppButton(
      key: key,
      child: child,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
      height: height,
      padding: padding,
      foregroundColor: foregroundColor,
      borderRadius: borderRadius,
      elevation: elevation,
      tapTargetSize: tapTargetSize,
      buttonType: ButtonType.outlined,
    );
  }

  factory AppButton.text({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    Color? foregroundColor,
    MaterialTapTargetSize? tapTargetSize,
  }) {
    return AppButton(
      key: key,
      child: child,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
      height: height,
      padding: padding,
      foregroundColor: foregroundColor,
      tapTargetSize: tapTargetSize,
      buttonType: ButtonType.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? theme.primaryColor;
    final effectiveForegroundColor = foregroundColor ?? Colors.white;
    final effectiveDisabledBackgroundColor = disabledBackgroundColor ??
        effectiveBackgroundColor.withValues(alpha: (0.5 * 255).round().toDouble());
    final effectiveDisabledForegroundColor = disabledForegroundColor ??
        effectiveForegroundColor.withValues(alpha: (0.5 * 255).round().toDouble());

    final isButtonDisabled = isLoading || isDisabled || onPressed == null;

    final buttonStyle = _getButtonStyle(theme, effectiveBackgroundColor,
        effectiveForegroundColor, effectiveDisabledBackgroundColor,
        effectiveDisabledForegroundColor, isButtonDisabled);

    final buttonChild = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : child;

    switch (buttonType) {
      case ButtonType.elevated:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: isButtonDisabled ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          ),
        );
      case ButtonType.outlined:
        return SizedBox(
          width: width,
          height: height,
          child: OutlinedButton(
            onPressed: isButtonDisabled ? null : onPressed,
            style: _getOutlinedButtonStyle(theme, effectiveForegroundColor,
                effectiveDisabledForegroundColor, isButtonDisabled),
            child: buttonChild,
          ),
        );
      case ButtonType.text:
        return SizedBox(
          width: width,
          height: height,
          child: TextButton(
            onPressed: isButtonDisabled ? null : onPressed,
            style: _getTextButtonStyle(theme, effectiveForegroundColor,
                effectiveDisabledForegroundColor, isButtonDisabled),
            child: buttonChild,
          ),
        );
    }
  }

  ButtonStyle _getButtonStyle(
    ThemeData theme,
    Color effectiveBackgroundColor,
    Color effectiveForegroundColor,
    Color effectiveDisabledBackgroundColor,
    Color effectiveDisabledForegroundColor,
    bool isButtonDisabled,
  ) {
    return ElevatedButton.styleFrom(
      backgroundColor: isButtonDisabled
          ? effectiveDisabledBackgroundColor
          : effectiveBackgroundColor,
      foregroundColor: isButtonDisabled
          ? effectiveDisabledForegroundColor
          : effectiveForegroundColor,
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
      elevation: elevation,
      side: side,
      tapTargetSize: tapTargetSize,
      animationDuration: animationDuration,
      enableFeedback: true,
    );
  }

  ButtonStyle _getOutlinedButtonStyle(
    ThemeData theme,
    Color effectiveForegroundColor,
    Color effectiveDisabledForegroundColor,
    bool isButtonDisabled,
  ) {
    return OutlinedButton.styleFrom(
      foregroundColor: isButtonDisabled
          ? effectiveDisabledForegroundColor
          : effectiveForegroundColor,
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
      side: MaterialStateBorderSide.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return BorderSide(
            color: effectiveDisabledForegroundColor.withOpacity(0.5),
          );
        }
        return BorderSide(color: effectiveForegroundColor);
      }),
      tapTargetSize: tapTargetSize,
      animationDuration: animationDuration,
      enableFeedback: true,
    );
  }

  ButtonStyle _getTextButtonStyle(
    ThemeData theme,
    Color effectiveForegroundColor,
    Color effectiveDisabledForegroundColor,
    bool isButtonDisabled,
  ) {
    return TextButton.styleFrom(
      foregroundColor: isButtonDisabled
          ? effectiveDisabledForegroundColor
          : effectiveForegroundColor,
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
      tapTargetSize: tapTargetSize,
      animationDuration: animationDuration,
      enableFeedback: true,
    );
  }
}

enum ButtonType {
  elevated,
  outlined,
  text,
}
