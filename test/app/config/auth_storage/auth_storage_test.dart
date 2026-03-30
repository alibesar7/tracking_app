import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';

void main() {
  late AuthStorage authStorage;

  setUp(() {
    authStorage = AuthStorage();
    SharedPreferences.setMockInitialValues({});
  });

  group('AuthStorage Tests', () {
    test(
      'saveToken should call setString with correct key and value',
      () async {
        const token = 'test_token_123';

        await authStorage.saveToken(token);

        final storedToken = await authStorage.getToken();
        expect(storedToken, token);
      },
    );

    test('getRememberMe should return false by default if not set', () async {
      final result = await authStorage.getRememberMe();

      expect(result, false);
    });

    test('setRememberMe should store boolean value correctly', () async {
      await authStorage.setRememberMe(true);

      final result = await authStorage.getRememberMe();
      expect(result, true);
    });

    test('saveUserJson and getUserJson should handle string data', () async {
      const userJson = '{"id": 1, "name": "Gemini"}';

      await authStorage.saveUserJson(userJson);
      final result = await authStorage.getUserJson();

      expect(result, userJson);
    });

    test('clearOrderId should remove the order id from prefs', () async {
      await authStorage.saveOrderId('order_999');

      await authStorage.clearOrderId();
      final result = await authStorage.getOrderId();

      expect(result, null);
    });

    test('clearAll should reset all stored values', () async {
      await authStorage.saveToken('token');
      await authStorage.setRememberMe(true);
      await authStorage.saveOrderId('123');

      await authStorage.clearAll();

      expect(await authStorage.getToken(), null);
      expect(await authStorage.getRememberMe(), false);
      expect(await authStorage.getOrderId(), null);
    });
  });
}
