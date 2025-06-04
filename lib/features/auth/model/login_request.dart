// lib/features/auth/models/login_request.dart
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

// lib/features/auth/models/login_response.dart
class LoginResponse {
  final String token;
  final int userId;

  LoginResponse({
    required this.token,
    required this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      userId: json['user_id'] as int,
    );
  }
}

// lib/features/auth/models/auth_error.dart
class AuthError {
  final String errorMsg;

  AuthError({
    required this.errorMsg,
  });

  factory AuthError.fromJson(Map<String, dynamic> json) {
    return AuthError(
      errorMsg: json['error_msg'] as String,
    );
  }
}