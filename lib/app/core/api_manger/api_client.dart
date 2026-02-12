
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';
import 'package:tracking_app/app/core/values/app_endpoint_strings.dart';

import '../../../features/auth/data/models/response/logout_response_dto/logout_response_dto.dart';
part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio) = _ApiClient;
  @GET(AppEndpointString.logout)
  Future<HttpResponse<LogoutResponseDto>> logout();

}
