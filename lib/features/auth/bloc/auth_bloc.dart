import 'package:bank/core/local_storage/hive.dart';
import 'package:bank/features/auth/bloc/auth_event.dart';
import 'package:bank/features/auth/bloc/auth_state.dart';
import 'package:bank/features/auth/model/login_request.dart' as auth_models;
import 'package:bank/features/auth/model/register_request.dart' as auth_models;
import 'package:bank/features/auth/services/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      final loginRequest = auth_models.LoginRequest(
        email: event.email,
        password: event.password,
      );
      
      final response = await _authRepository.login(loginRequest);
      
      await HiveStorage.saveAuthData(
        token: response.token,
        userId: response.userId,
      );
      
      emit(AuthSuccess(
        token: response.token,
        userId: response.userId,
      ));
    } on auth_models.AuthError catch (e) {
      emit(AuthError(message: e.errorMsg));
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      final registerRequest = auth_models.RegisterRequest(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      
      final response = await _authRepository.register(registerRequest);
      
      await HiveStorage.saveAuthData(
        token: response.token,
        userId: response.userId,
      );
      
      emit(AuthSuccess(
        token: response.token,
        userId: response.userId,
      ));
    } on auth_models.AuthError catch (e) {
      emit(AuthError(message: e.errorMsg));
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred'));
    }
  }

  

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    if (HiveStorage.isLoggedIn) {
      final token = HiveStorage.getToken()!;
      final userId = HiveStorage.getUserId()!;
      emit(AuthSuccess(token: token, userId: userId));
    } else {
      emit(AuthLoggedOut());
    }
  }
}