import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:tracking_app/features/auth/data/model/request/LoginRequest.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio) = _ApiClient;
  @POST("drivers/signin")
  Future<LoginResponse> login(@Body() LoginRequest request);
}
