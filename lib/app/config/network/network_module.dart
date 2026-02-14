import 'package:dio/dio.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/network/interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../core/api_manger/api_client.dart';
import '../../core/values/app_endpoint_strings.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(AuthStorage authStorage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppEndpointString.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(AppInterceptor(authStorage));

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    return dio;
  }

  @lazySingleton
  ApiClient authApiClient(Dio dio) => ApiClient(dio);
}
