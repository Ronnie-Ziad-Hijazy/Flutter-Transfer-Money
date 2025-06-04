import 'package:bank/core/local_storage/hive.dart';
import 'package:bank/core/network/dio.dart';
import 'package:bank/features/home/model/user_balance.dart';
import 'package:dio/dio.dart';

class HomeRepository {
  final DioClient _dioClient = DioClient();

  Future<UserBalance> getUserBalance() async {
    try {
      final token = HiveStorage.getToken();
      
      final response = await _dioClient.dio.get(
        '/get-balance',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return UserBalance.fromJson(response.data);
      } else {
        throw HomeError(message: 'Failed to fetch balance');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic>) {
          throw HomeError.fromJson(errorData);
        }
      }
      
      
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw HomeError(message: 'Connection timeout. Please try again.');
        case DioExceptionType.connectionError:
          throw HomeError(message: 'No internet connection.');
        case DioExceptionType.badResponse:
          if (e.response?.statusCode == 401) {
            throw HomeError(message: 'Session expired. Please login again.');
          }
          throw HomeError(message: 'Server error. Please try again later.');
        default:
          throw HomeError(message: 'Something went wrong. Please try again.');
      }
    } catch (e) {
      if (e is HomeError) {
        rethrow;
      }
      throw HomeError(message: 'An unexpected error occurred.');
    }
  }

  Future<TransactionResponse> sendMoney(SendMoneyRequest request) async {
    try {
      final token = HiveStorage.getToken();
      
      final response = await _dioClient.dio.post(
        '/send-money',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return TransactionResponse.fromJson(response.data);
      } else {
        throw HomeError(message: 'Transaction failed');
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic>) {
          throw HomeError.fromJson(errorData);
        }
      }
      
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw HomeError(message: 'Connection timeout. Please try again.');
        case DioExceptionType.connectionError:
          throw HomeError(message: 'No internet connection.');
        case DioExceptionType.badResponse:
          if (e.response?.statusCode == 401) {
            throw HomeError(message: 'Session expired. Please login again.');
          } else if (e.response?.statusCode == 400) {
            throw HomeError(message: 'Invalid transaction. Please check the details.');
          } else if (e.response?.statusCode == 403) {
            throw HomeError(message: 'Insufficient balance or transaction not allowed.');
          }
          throw HomeError(message: 'Transaction failed. Please try again later.');
        default:
          throw HomeError(message: 'Something went wrong. Please try again.');
      }
    } catch (e) {
      if (e is HomeError) {
        rethrow;
      }
      throw HomeError(message: 'An unexpected error occurred.');
    }
  }
}