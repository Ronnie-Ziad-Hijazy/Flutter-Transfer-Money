import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {
  static const String _authBoxName = 'auth_box';
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  
  static Box? _authBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _authBox = await Hive.openBox(_authBoxName);
  }

  static Future<void> saveToken(String token) async {
    await _authBox?.put(_tokenKey, token);
  }

  static Future<void> saveUserId(int userId) async {
    await _authBox?.put(_userIdKey, userId);
  }

  static Future<void> saveAuthData({
    required String token,
    required int userId,
  }) async {
    await Future.wait([
      saveToken(token),
      saveUserId(userId),
    ]);
  }

  static String? getToken() {
    return _authBox?.get(_tokenKey);
  }

  static int? getUserId() {
    return _authBox?.get(_userIdKey);
  }

  static Future<void> clearAuthData() async {
    await Future.wait([
      _authBox?.delete(_tokenKey) ?? Future.value(),
      _authBox?.delete(_userIdKey) ?? Future.value(),
    ]);
  }

  static bool get isLoggedIn {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> closeBox() async {
    await _authBox?.close();
  }
}