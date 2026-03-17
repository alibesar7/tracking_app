import 'package:dio/dio.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';

class AppInterceptor extends Interceptor {
  final AuthStorage tokenStorage;
  AppInterceptor(this.tokenStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.uri.host.contains('googleapis.com')) {
      final token = await tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    super.onRequest(options, handler);
  }
}
