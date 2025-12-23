import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final bool filled;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool autofocus;
  final String? restorationId;
  final MouseCursor? mouseCursor;
  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final Clip clipBehavior;
  final String? semanticLabel;
  final bool enableIMEPersonalizedLearning;
  final bool enableAdaptiveKeyboard;
  final TapRegionCallback? onTapOutside;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.style,
    this.hintStyle,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.contentPadding,
    this.fillColor,
    this.filled = true,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.autofocus = false,
    this.restorationId,
    this.mouseCursor,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.clipBehavior = Clip.hardEdge,
    this.semanticLabel,
    this.enableIMEPersonalizedLearning = true,
    this.enableAdaptiveKeyboard = true,
    this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveHintStyle = hintStyle ?? theme.textTheme.bodyMedium?.copyWith(
      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
    );

    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon != null
            ? IconTheme(
                data: IconThemeData(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  size: 22,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 12),
                  child: prefixIcon!,
                ),
              )
            : null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: suffixIcon,
              )
            : null,
        border: border ?? theme.inputDecorationTheme.border,
        enabledBorder: enabledBorder ?? theme.inputDecorationTheme.enabledBorder,
        focusedBorder: focusedBorder ?? theme.inputDecorationTheme.focusedBorder,
        errorBorder: errorBorder,
        contentPadding: contentPadding ?? theme.inputDecorationTheme.contentPadding,
        fillColor: fillColor ?? theme.inputDecorationTheme.fillColor,
        filled: filled,
        hintStyle: effectiveHintStyle,
        isDense: true,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      enabled: enabled,
      readOnly: readOnly,
      style: style ?? theme.textTheme.bodyLarge?.copyWith(
        
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      autofocus: autofocus,
      restorationId: restorationId,
      mouseCursor: mouseCursor,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      buildCounter: buildCounter,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      clipBehavior: clipBehavior,
      onTapOutside: onTapOutside ?? (event) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
