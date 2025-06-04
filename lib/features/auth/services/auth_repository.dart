import 'package:bank/core/network/dio.dart';
import 'package:bank/features/auth/model/login_request.dart';
import 'package:bank/features/auth/model/register_request.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final DioClient _dioClient = DioClient();

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        '/login',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw AuthError(errorMsg: 'Login failed');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic> && errorData.containsKey('error_msg')) {
          throw AuthError.fromJson(errorData);
        }
      }
      
      // Handle different types of errors
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AuthError(errorMsg: 'Connection timeout. Please try again.');
        case DioExceptionType.connectionError:
          throw AuthError(errorMsg: 'No internet connection.');
        case DioExceptionType.badResponse:
          throw AuthError(errorMsg: 'Server error. Please try again later.');
        default:
          throw AuthError(errorMsg: 'Something went wrong. Please try again.');
      }
    } catch (e) {
      if (e is AuthError) {
        rethrow;
      }
      throw AuthError(errorMsg: 'An unexpected error occurred.');
    }
  }

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        '/register',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return RegisterResponse.fromJson(response.data);
      } else {
        throw AuthError(errorMsg: 'Registration failed');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic> && errorData.containsKey('error_msg')) {
          throw AuthError.fromJson(errorData);
        }
      }
      
      // Handle different types of errors
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw AuthError(errorMsg: 'Connection timeout. Please try again.');
        case DioExceptionType.connectionError:
          throw AuthError(errorMsg: 'No internet connection.');
        case DioExceptionType.badResponse:
          throw AuthError(errorMsg: 'Server error. Please try again later.');
        default:
          throw AuthError(errorMsg: 'Something went wrong. Please try again.');
      }
    } catch (e) {
      if (e is AuthError) {
        rethrow;
      }
      throw AuthError(errorMsg: 'An unexpected error occurred.');
    }
  }
}