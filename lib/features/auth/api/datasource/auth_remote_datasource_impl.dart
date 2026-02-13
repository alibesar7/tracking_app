import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/models/response/country_model.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicles_response_model.dart';
import 'package:tracking_app/features/auth/data/models/request/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_response_model.dart';

import '../../../../app/core/api_manger/api_client.dart';
import '../../../../app/core/network/safe_api_call.dart';
import '../../data/datasource/auth_remote_datasource.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  ApiClient apiClient;
  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ApiResult<VehiclesResponse>> getAllVehicle() {
    return safeApiCall<VehiclesResponse>(call: () => apiClient.getAllVehicle());
  }

  @override
  Future<ApiResult<ApplyResponseModel>> apply(
    ApplyRequestModel applyRequestModel,
  ) {
    return safeApiCall<ApplyResponseModel>(
      call: () async {
        final formData = FormData.fromMap({
          "country": applyRequestModel.country,
          "firstName": applyRequestModel.firstName,
          "lastName": applyRequestModel.lastName,
          "vehicleType": applyRequestModel.vehicleType,
          "vehicleNumber": applyRequestModel.vehicleNumber,
          "email": applyRequestModel.email,
          "phone": applyRequestModel.phone,
          "NID": applyRequestModel.NID,
          "password": applyRequestModel.password,
          "rePassword": applyRequestModel.rePassword,
          "gender": applyRequestModel.gender,
        });

        if (applyRequestModel.vehicleLicense != null) {
          formData.files.add(
            MapEntry(
              "vehicleLicense",
              await MultipartFile.fromFile(
                applyRequestModel.vehicleLicense!.path,
                filename: applyRequestModel.vehicleLicense!.path
                    .split('/')
                    .last,
              ),
            ),
          );
        }

        if (applyRequestModel.NIDimg != null) {
          formData.files.add(
            MapEntry(
              "NIDImg",
              await MultipartFile.fromFile(
                applyRequestModel.NIDimg!.path,
                filename: applyRequestModel.NIDimg!.path.split('/').last,
              ),
            ),
          );
        }

        return apiClient.apply(formData);
      },
    );
  }

  @override
  Future<List<CountryModel>> getCountries() async {
    final String response = await rootBundle.loadString(
      'assets/data/country.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => CountryModel.fromJson(json)).toList();
  }
}
