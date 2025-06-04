// lib/features/auth/widgets/login_content.dart
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

class _LoginContentState extends State<LoginContent> with TickerProviderStateMixin {
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerKey = GlobalKey<FormState>();
  
  // Login controllers
  final TextEditingController emailController = TextEditingController(text: 'ronnyhijazy@gmail.com');
  final TextEditingController passwordController = TextEditingController();
  
  // Register controllers
  final TextEditingController registerNameController = TextEditingController();
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPasswordController = TextEditingController();
  
  bool isLoginMode = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    registerNameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      isLoginMode = !isLoginMode;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _login() {
    if (!_loginKey.currentState!.validate()) {
      return;
    }
    
    context.read<AuthBloc>().add(
      LoginEvent(
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );
  }

  void _register() {
    if (!_registerKey.currentState!.validate()) {
      return;
    }
    
    context.read<AuthBloc>().add(
      RegisterEvent(
        name: registerNameController.text.trim(),
        email: registerEmailController.text.trim(),
        password: registerPasswordController.text,
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

  Widget _buildLoginForm() {
    return Form(
      key: _loginKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmailTextField(
            emailController: emailController,
            action: TextInputAction.next,
          ),
          // const SizedBox(height: 24),
          PasswordTextField(
            passwordController: passwordController,
            action: TextInputAction.done,
          ),
          // const SizedBox(height: 32),
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
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _registerKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NameTextField(
            nameController: registerNameController,
            action: TextInputAction.next,
          ),
          // const SizedBox(height: 24),
          EmailTextField(
            emailController: registerEmailController,
            action: TextInputAction.next,
          ),
          // const SizedBox(height: 24),
          PasswordTextField(
            passwordController: registerPasswordController,
            hint: 'Password',
            action: TextInputAction.done,
          ),
          // const SizedBox(height: 32),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return loginButton(
                'Create Account',
                state is AuthLoading ? null : _register,
                isLoading: state is AuthLoading,
              );
            },
          ),
        ],
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
          final message = isLoginMode ? 'Login successful!' : 'Account created successfully!';
          _showSnackBar(message, isError: false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      },
      child: Stack(
        children: [
          // Welcome text
          Positioned(
            top: 136,
            left: 24,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                isLoginMode ? 'Welcome\nBack' : 'Create\nAccount',
                key: ValueKey(isLoginMode),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          // Main form content
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(isLoginMode),
                      child: isLoginMode ? _buildLoginForm() : _buildRegisterForm(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom switch section
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: _toggleMode,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                      ),
                      children: [
                        TextSpan(
                          text: isLoginMode 
                            ? 'Don\'t have an account? ' 
                            : 'Already have an account? ',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: isLoginMode ? 'Sign Up' : 'Sign In',
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
          ),
        ],
      ),
    );
  }
}