

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/models/response/country_model.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicles_response_model.dart';

import '../../../../app/core/api_manger/api_client.dart';
import '../../../../app/core/network/safe_api_call.dart';
import '../../data/datasource/auth_remote_datasource.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  ApiClient apiClient;
  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ApiResult<VehiclesResponse>> getAllVehicle() {
    return safeApiCall<VehiclesResponse>(
          call: () => apiClient.getAllVehicle(),
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
