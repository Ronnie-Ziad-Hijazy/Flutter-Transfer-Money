abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String token;
  final int userId;

  AuthSuccess({
    required this.token,
    required this.userId,
  });
}

class AuthError extends AuthState {
  final String message;

  AuthError({
    required this.message,
  });
}

class AuthLoggedOut extends AuthState {}
