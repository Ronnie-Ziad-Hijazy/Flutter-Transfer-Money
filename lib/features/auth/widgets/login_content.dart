import 'package:bank/core/common/auth_text_field.dart';
import 'package:bank/core/constants/app_colors.dart';
import 'package:bank/features/auth/bloc/auth_event.dart';
import 'package:bank/features/auth/bloc/auth_state.dart';
import 'package:bank/features/auth/widgets/login_btn.dart';
import 'package:bank/features/auth/bloc/auth_bloc.dart';
import 'package:bank/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginContent extends StatefulWidget {
  const LoginContent({super.key});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController(text: 'ronnyhijazy@gmail.com');
  final TextEditingController passwordController = TextEditingController(text: '123123123');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_key.currentState!.validate()) {
      return;
    }
    
    context.read<AuthBloc>().add(
      LoginEvent(
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _showSnackBar(state.message);
        } else if (state is AuthSuccess) {
          _showSnackBar('Login successful!', isError: false);
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
       
        }
      },
      child: Stack(
        children: [
          const Positioned(
            top: 136,
            left: 24,
            child: Text(
              'Welcome\nBack',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EmailTextField(emailController: emailController),
                  PasswordTextField(passwordController: passwordController),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return loginButton(
                        'Login',
                        state is AuthLoading ? null : _login,
                        isLoading: state is AuthLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                    ),
                    children: [
                      TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}