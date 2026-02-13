import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tracking_app/app/core/values/app_endpoint_strings.dart';
import 'package:tracking_app/features/auth/data/model/response/change_password_dto.dart';
import 'package:tracking_app/features/auth/data/model/request/LoginRequest.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import '../../../features/auth/data/models/response/apply_response_model.dart';
import '../../../features/auth/data/models/request/apply_request_model.dart';
import '../../../features/auth/data/models/response/vehicles_response_model.dart';
import '../values/app_endpoint_strings.dart';

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

  @GET(AppEndpointString.getVehicles)
  Future<HttpResponse<VehiclesResponse>> getAllVehicle();

  @POST(AppEndpointString.apply)
  @MultiPart()
  Future<HttpResponse<ApplyResponseModel>> apply(@Body() FormData formData);
}
