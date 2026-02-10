import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';

@lazySingleton
class AuthStorage {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';
  static const _rememberMeKey = 'remember_me';

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

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

  Future<void> saveUser(DriverModel user) async {
    final prefs = await _prefs;
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  Future<DriverModel?> getUser() async {
    final prefs = await _prefs;
    final userString = prefs.getString(_userKey);
    if (userString == null) return null;
    try {
      final userMap = jsonDecode(userString);
      return DriverModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearUser() async {
    final prefs = await _prefs;
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
  }
}
