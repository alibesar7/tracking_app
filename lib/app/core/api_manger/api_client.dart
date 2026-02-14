import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/dio.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/core/values/app_endpoint_strings.dart';
import 'package:tracking_app/features/auth/data/models/request/forget_password_request.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/data/models/request/verifyreset_request.dart';
import 'package:tracking_app/features/auth/data/models/response/forgetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/resetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/verifyreset_response.dart';

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
}
