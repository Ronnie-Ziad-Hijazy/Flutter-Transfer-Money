import 'package:bank/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnValidate = String? Function(String?);

class GeneralTextField extends StatelessWidget {
  const GeneralTextField({
    Key? key,
    required this.hint,
    required this.controller,
    this.onValidate,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.isSecure = false,
    this.action = TextInputAction.next,
    this.inputFormatters,
    this.prefixText,
    this.isEditable = true,
    this.prefixIcon,
    this.borderRadius = 25.0,
  }) : super(key: key);

  final TextInputType? keyboardType;
  final TextInputAction? action;
  final String hint;
  final TextEditingController controller;
  final Widget? suffix;
  final bool isSecure;
  final OnValidate? onValidate;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final bool isEditable;
  final IconData? prefixIcon;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 4,
            shadowColor: Colors.black26,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
            child: TextFormField(
              cursorHeight: 20,
              keyboardType: keyboardType,
              textInputAction: action,
              controller: controller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: inputFormatters,
              obscureText: isSecure,
              enabled: isEditable,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: AppColors.black,
              ),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                // Remove error text from input decoration to handle it separately
                errorStyle: const TextStyle(height: 0, fontSize: 0),
                
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: AppColors.green400, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: AppColors.red, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: AppColors.red, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
                
                filled: true,
                fillColor: isEditable ? Colors.white : Colors.grey.shade50,
                
                hintText: hint,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
                
                prefixIcon: prefixIcon != null 
                  ? Icon(
                      prefixIcon,
                      color: Colors.grey.shade600,
                      size: 20,
                    ) 
                  : null,
                prefixText: prefixText != null ? '$prefixText ' : null,
                prefixStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: AppColors.black,
                ),
                
                suffixIcon: suffix,
                
                contentPadding: EdgeInsets.symmetric(
                  horizontal: prefixIcon != null ? 12 : 20,
                  vertical: 15,
                ),
              ),
              validator: onValidate,
            ),
          ),
          
          // Custom error message display
          if (onValidate != null)
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                final errorMessage = onValidate!(value.text);
                if (errorMessage != null && errorMessage.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, top: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            errorMessage,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
    );
  }
}