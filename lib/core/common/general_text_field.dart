import 'package:bank/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnValidate = String? Function(String?)?;

class GeneralTextField extends StatelessWidget {
  const GeneralTextField({
    Key? key,
    required this.hint,
    required this.controller,
    required this.onValidate,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.prefixIcon,
    this.isSecure = false,
    this.action = TextInputAction.next,
    this.inputFormatters,
    this.prefixText,
    this.isEditable,
    this.hintStyle,
  }) : super(key: key);

  final TextInputType? keyboardType;
  final TextInputAction? action;
  final String hint;
  final TextEditingController controller;
  final Widget? suffix;
  final IconData? prefixIcon;
  final bool? isSecure;
  final OnValidate onValidate;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final bool? isEditable;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 60,
        child: Material(
          elevation: 0,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextFormField(
            textAlignVertical: TextAlignVertical.bottom,
            keyboardType: keyboardType,
            textInputAction: action,
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: inputFormatters,
            obscureText: isSecure ?? false,
            enabled: isEditable ?? true,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: AppColors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: AppColors.red, width: 1),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: hintStyle ?? Theme.of(context).textTheme.labelMedium,
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
              suffixIcon: suffix,
              prefixText: prefixText != null ? '$prefixText ' : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            validator: onValidate,
          ),
        ),
      ),
    );
  }
}
