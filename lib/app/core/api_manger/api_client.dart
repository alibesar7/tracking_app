import 'dart:io';
import 'package:dio/dio.dart';
import 'package:tracking_app/app/core/values/app_endpoint_strings.dart';
import 'package:tracking_app/features/auth/data/model/response/change_password_dto.dart';
import 'package:tracking_app/features/auth/data/model/request/LoginRequest.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:retrofit/retrofit.dart';
import '../../../features/auth/data/models/response/apply_response_model.dart';
import '../../../features/auth/data/models/response/vehicles_response_model.dart';
import 'package:tracking_app/app/core/values/api_constants.dart';
import 'package:tracking_app/features/profile/data/models/requests/edit_profile_request.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';
part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio) = _ApiClient;

  @PATCH(AppEndpointString.changePassword)
  Future<HttpResponse<ChangePasswordDto>> changePassword({
    @Header(ApiConstants.authorization) required String token,
    @Body() required Map<String, dynamic> body,
  });

  @POST(AppEndpointString.login)
  Future<LoginResponse> login(@Body() LoginRequest request);

  @GET(AppEndpointString.getVehicles)
  Future<HttpResponse<VehiclesResponse>> getAllVehicle();

  @POST(AppEndpointString.apply)
  @MultiPart()
  Future<HttpResponse<ApplyResponseModel>> apply(@Body() FormData formData);

  @PUT(AppEndpointString.editProfile)
  Future<HttpResponse<EditProfileResponse>> editProfile({
    @Header(ApiConstants.authorization) required String token,
    @Body() required EditProfileRequest request,
  });

  @MultiPart()
  @PUT(AppEndpointString.uploadPhoto)
  Future<HttpResponse<EditProfileResponse>> uploadPhoto({
    @Header(ApiConstants.authorization) required String token,
    @Part(name: ApiConstants.photo) required File photo,
  });

  @GET(AppEndpointString.getProfile)
  Future<HttpResponse<EditProfileResponse>> getProfile({
    @Header(ApiConstants.authorization) required String token,
  });
}
