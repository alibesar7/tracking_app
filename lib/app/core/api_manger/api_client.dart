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
import 'package:tracking_app/features/auth/data/models/request/forget_password_request.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/data/models/request/verifyreset_request.dart';
import 'package:tracking_app/features/auth/data/models/response/forgetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/resetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/verifyreset_response.dart';
import '../../../features/auth/data/models/response/apply_response_model.dart';
import '../../../features/auth/data/models/request/apply_request_model.dart';
import '../../../features/auth/data/models/response/vehicles_response_model.dart';
import '../values/app_endpoint_strings.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: AppEndpointString.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio) = _ApiClient;

  @POST(AppEndpointString.sendEmail)
  Future<HttpResponse<ForgetpasswordResponse>> forgetPassword(
    @Body() ForgetPasswordRequest request,
  );
  @PUT(AppEndpointString.resetPassword)
  Future<HttpResponse<ResetpasswordResponse>> resetPassword(
    @Body() ResetPasswordRequest request,
  );
  @POST(AppEndpointString.verifyResetCode)
  Future<HttpResponse<VerifyresetResponse>> verifyResetCode(
    @Body() VerifyResetRequest request,
  );
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
