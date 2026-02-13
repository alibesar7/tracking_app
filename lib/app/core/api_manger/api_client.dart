import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/http.dart';
import 'package:tracking_app/app/core/values/api_constants.dart';
import 'package:tracking_app/app/core/values/app_endpoint_strings.dart';
import 'package:tracking_app/features/profile/data/models/requests/edit_profile_request.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';
part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio) = _ApiClient;

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
