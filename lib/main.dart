// main.dart
import 'package:bank/core/constants/app_colors.dart';
import 'package:bank/core/local_storage/hive.dart';
import 'package:bank/core/network/dio.dart';
import 'package:bank/features/auth/bloc/auth_bloc.dart';
import 'package:bank/features/auth/pages/login_page.dart';
import 'package:bank/features/home/bloc/home_bloc.dart';
import 'package:bank/features/home/pages/home_page.dart';
import 'package:bank/features/home/services/home_repository.dart';
import 'package:bank/features/auth/services/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveStorage.init();

  DioClient().init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRepository()),
        ),
        BlocProvider(
          create: (context) => HomeBloc(HomeRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bank App',
        theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: kPrimaryColor,
                fontFamily: 'Montserrat',
              ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if (HiveStorage.isLoggedIn) {
      return const HomeScreen();
    } else {
      return const LoginPage();
    }
  }
}