import 'package:bank/animations/change_screen_animation.dart';
import 'package:bank/core/common/auth_text_field.dart';
import 'package:bank/core/common/helper_functions.dart';
import 'package:bank/features/auth/bloc/auth_bloc.dart';
import 'package:bank/features/auth/bloc/auth_event.dart';
import 'package:bank/features/auth/bloc/auth_state.dart';
import 'package:bank/features/auth/widgets/bottom_text.dart';
import 'package:bank/features/auth/widgets/top_text.dart';
import 'package:bank/features/home/pages/home_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with TickerProviderStateMixin {
  late final List<Widget> createAccountContent;
  late final List<Widget> loginContent;
  

  // Form controllers
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  final TextEditingController _registerNameController = TextEditingController();
  final TextEditingController _registerEmailController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();

  // Form keys for validation
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    ChangeScreenAnimation.dispose();
    super.dispose();
  }

  // String? _validateEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Email is required';
  //   }
  //   final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  //   if (!emailRegex.hasMatch(value)) {
  //     return 'Please enter a valid email';
  //   }
  //   return null;
  // }

  // String? _validatePassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Password is required';
  //   }
  //   if (value.length < 8) {
  //     return 'Password must be at least 8 characters';
  //   }
  //   return null;
  // }

  // String? _validateName(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Name is required';
  //   }
  //   if (value.length < 2) {
  //     return 'Name must be at least 2 characters';
  //   }
  //   return null;
  // }

  Widget loginButton({
    required String title,
    required VoidCallback onPressed,
    required bool isLoading,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: const Color.fromARGB(255, 38, 171, 76),
          shape: const StadiumBorder(),
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }

  void _performLogin() {
    if (_loginFormKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginEvent(
              email: _loginEmailController.text.trim(),
              password: _loginPasswordController.text,
            ),
          );
    }
  }

  void _performRegistration() {
    if (_registerFormKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegisterEvent(
              name: _registerNameController.text.trim(),
              email: _registerEmailController.text.trim(),
              password: _registerPasswordController.text,
            ),
          );
    }
  }

  @override
  void initState() {
    createAccountContent = [
      NameTextField(
        nameController: _registerNameController,
        hint: 'Name',
        action: TextInputAction.next,
      ),
      EmailTextField(
        emailController: _registerEmailController,
      ),
      PasswordTextField(
        passwordController: _registerPasswordController,
        hint: 'Password',
        action: TextInputAction.done,
       
      ),
      BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return loginButton(
            title: 'Sign Up',
            onPressed: _performRegistration,
            isLoading: state is AuthLoading,
          );
        },
      ),
    ];

    loginContent = [
      EmailTextField(
        emailController: _loginEmailController,
      ),
      PasswordTextField(
        passwordController: _loginPasswordController,
        hint: 'Password',
        action: TextInputAction.done,
      ),
      BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return loginButton(
            title: 'Log In',
            onPressed: _performLogin,
            isLoading: state is AuthLoading,
          );
        },
      ),
    ];

    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: createAccountContent.length,
      loginItems: loginContent.length,
    );

    for (var i = 0; i < createAccountContent.length; i++) {
      createAccountContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.createAccountAnimations[i],
        child: createAccountContent[i],
      );
    }

    for (var i = 0; i < loginContent.length; i++) {
      loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginContent[i],
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication successful!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          // Navigate to home screen
          // Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: Stack(
        children: [
          const Positioned(
            top: 136,
            left: 24,
            child: TopText(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Stack(
              children: [
                Form(
                  key: _registerFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: createAccountContent,
                  ),
                ),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: loginContent,
                  ),
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: BottomText(),
            ),
          ),
        ],
      ),
    );
  }
}