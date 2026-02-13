import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tracking_app/app/core/values/app_endpoint_strings.dart';
import 'package:tracking_app/features/auth/data/model/response/change_password_dto.dart';
import 'package:tracking_app/features/auth/data/model/request/LoginRequest.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio) = _ApiClient;

  @PATCH(AppEndpointString.changePassword)
  Future<HttpResponse<ChangePasswordDto>> changePassword(
    @Body() Map<String, dynamic> body,
  );
  @POST("drivers/signin")
  Future<LoginResponse> login(@Body() LoginRequest request);
}
