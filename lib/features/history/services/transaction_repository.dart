import 'package:bank/core/network/dio.dart';
import 'package:bank/features/history/model/transaction_model.dart';
import 'package:dio/dio.dart';
import 'package:bank/core/local_storage/hive.dart';

class TransactionRepository {
  final DioClient _dioClient = DioClient();

  Future<List<TransactionModel>> fetchTransactions() async {
    try {
      final token = HiveStorage.getToken();
      final response = await _dioClient.dio.get(
        '/wallet-history',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final data = response.data as List;
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception('Connection timeout. Please try again.');
        case DioExceptionType.connectionError:
          throw Exception('No internet connection.');
        case DioExceptionType.badResponse:
          if (e.response?.statusCode == 401) {
            throw Exception('Session expired. Please login again.');
          }
          throw Exception('Server error. Please try again later.');
        default:
          throw Exception('Something went wrong. Please try again.');
      }
    } catch (_) {
      throw Exception('An unexpected error occurred.');
    }
  }
}
