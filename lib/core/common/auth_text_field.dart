import 'package:bank/core/common/general_text_field.dart';
import 'package:bank/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required this.emailController,
    this.action = TextInputAction.next,
  });
  
  final TextEditingController emailController;
  final TextInputAction action;

  @override
  Widget build(BuildContext context) {
    return GeneralTextField(
      prefixIcon: Icons.mail_outline,
      keyboardType: TextInputType.emailAddress,
      hint: 'Email',
      controller: emailController,
      action: action,
      onValidate: (email) {
        if (email == null || email.isEmpty) {
          return 'Email is required';
        }
        
        // Email validation regex
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(email)) {
          return 'Please enter a valid email';
        }
        
        return null;
      },
    );
  }
}

// Updated PasswordTextField
class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.passwordController,
    this.hint,
    this.validate,
    this.action,
  });
  final TextEditingController passwordController;
  final String? hint;
  final String? Function(String?)? validate;
  final TextInputAction? action;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isSecure = true;
  
  @override
  Widget build(BuildContext context) {
    return GeneralTextField(
      prefixIcon: Icons.lock_outline,
      action: widget.action ?? TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      hint: widget.hint ?? 'Password',
      controller: widget.passwordController,
      isSecure: isSecure,
      suffix: GestureDetector(
        onTap: () {
          setState(() {
            isSecure = !isSecure;
          });
        },
        child: Icon(
          isSecure ? Icons.visibility : Icons.visibility_off,
        ),
      ),
      onValidate: (password) {
        if (password == null || password.isEmpty) {
          return 'Password is required';
        } else if (password.length < 8) {
          return 'Password must be at least 8 characters long';
        } else if (widget.validate != null) {
          return widget.validate!(password);
        }
        return null;
      },
    );
  }
}

// Updated NameTextField
class NameTextField extends StatelessWidget {
  const NameTextField({
    super.key,
    required this.nameController,
    this.hint = 'Name',
    this.action = TextInputAction.next,
  });
  
  final TextEditingController nameController;
  final String hint;
  final TextInputAction action;

  @override
  Widget build(BuildContext context) {
    return GeneralTextField(
      prefixIcon: Icons.person_outline,
      keyboardType: TextInputType.name,
      hint: hint,
      controller: nameController,
      action: action,
      onValidate: (name) {
        if (name == null || name.isEmpty) {
          return 'Name is required';
        }
        if (name.length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
    );
  }
}