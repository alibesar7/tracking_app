import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class AuthStorage {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';
  static const _rememberMeKey = 'remember_me';
  static const _orderIdKey = 'order_id';

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  Future<void> saveOrderId(String orderId) async {
    final prefs = await _prefs;
    await prefs.setString(_orderIdKey, orderId);
  }

  Future<String?> getOrderId() async {
    final prefs = await _prefs;
    return prefs.getString(_orderIdKey);
  }

  Future<void> clearOrderId() async {
    final prefs = await _prefs;
    await prefs.remove(_orderIdKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await _prefs;
    await prefs.remove(_tokenKey);
  }

  Future<void> saveUserJson(String json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json);
  }

  Future<String?> getUserJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<void> setRememberMe(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_rememberMeKey, value);
  }

  Future<bool> getRememberMe() async {
    final prefs = await _prefs;
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  Future<void> clearAll() async {
    await clearToken();
    await clearUser();
    await setRememberMe(false);
    await clearOrderId();
  }
}
