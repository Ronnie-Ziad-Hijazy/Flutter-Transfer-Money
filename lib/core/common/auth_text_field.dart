import 'package:bank/core/common/general_text_field.dart';
import 'package:flutter/material.dart';
// import 'package:regexpattern/regexpattern.dart';


class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required this.emailController,
  });
  final TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    return GeneralTextField(
      prefixIcon: Icons.mail_outline,
      keyboardType: TextInputType.emailAddress,
      hint: 'Email',
      controller: emailController,
      onValidate: (email) {
        if (email == null || email.isEmpty) {
          return 'email is required';
        }


        return null;
      },
    );
  }
}

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
      hint: widget.hint ??'password',
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
          return 'password is required';
        } else if (password.length < 8) {
          return 'password must be at least 8 characters long';
        } else if (widget.validate != null) {
          return widget.validate!(password);
        }
        return null;
      },
    );
  }
}