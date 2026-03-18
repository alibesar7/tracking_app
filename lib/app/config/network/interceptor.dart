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
    final token = await tokenStorage.getToken();

    final isFirebase = options.uri.host.contains('googleapis.com');

    if (!isFirebase && token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
