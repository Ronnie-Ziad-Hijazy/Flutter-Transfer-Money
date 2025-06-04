
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