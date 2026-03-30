import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart';
import 'package:tracking_app/app/core/api_manger/api_client.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/core/network/safe_api_call.dart';
import 'package:tracking_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:tracking_app/features/auth/data/model/request/LoginRequest.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:tracking_app/features/auth/data/models/request/forget_password_request.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/data/models/request/verifyreset_request.dart';
import 'package:tracking_app/features/auth/data/models/request/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/model/response/change_password_dto.dart';
import 'package:tracking_app/features/auth/data/models/response/forgetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/logout_response_dto/logout_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/response/resetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/verifyreset_response.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_response_model.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicles_response_model.dart';
import 'package:tracking_app/features/auth/data/models/response/country_model.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ApiResult<ForgetpasswordResponse>> forgetPassword(
    ForgetPasswordRequest request,
  ) {
    return safeApiCall(call: () => apiClient.forgetPassword(request));
  }

  @override
  Future<ApiResult<VerifyresetResponse>> verifyResetCode(
    VerifyResetRequest request,
  ) {
    return safeApiCall(call: () => apiClient.verifyResetCode(request));
  }

  @override
  Future<ApiResult<ResetpasswordResponse>> resetPassword(
    ResetPasswordRequest request,
  ) {
    return safeApiCall(call: () => apiClient.resetPassword(request));
  }

  @override
  Future<ApiResult<LoginResponse>> login(LoginRequest loginRequest) async {
    try {
      final response = await apiClient.login(loginRequest);
      return SuccessApiResult<LoginResponse>(data: response);
    } on DioException catch (e) {
      String errorMessage = 'unknownError';
      if (e.response?.statusCode == 401) {
        errorMessage = 'wrongEmailOrPassword';
      } else if (e.response?.data != null) {
        if (e.response!.data is Map<String, dynamic>) {
          errorMessage =
              e.response!.data['message'] ?? e.message ?? 'unknownError';
        } else {
          errorMessage = e.message ?? 'unknownError';
        }
      } else {
        errorMessage = e.message ?? 'unknownError';
      }
      return ErrorApiResult<LoginResponse>(error: errorMessage);
    } catch (e) {
      return ErrorApiResult<LoginResponse>(error: e.toString());
    }
  }

  @override
  Future<ApiResult<ChangePasswordDto>> changePassword({
    required String token,
    String? password,
    String? newPassword,
  }) {
    return safeApiCall<ChangePasswordDto>(
      call: () async {
        return apiClient.changePassword(
          token: "Bearer $token",
          body: {"password": password, "newPassword": newPassword},
        );
      },
    );
  }

  @override
  Future<ApiResult<VehiclesResponse>> getAllVehicle() {
    return safeApiCall(call: () => apiClient.getAllVehicle());
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

  @override
  Future<ApiResult<LogoutResponseDto>> logout(String token) {
    return safeApiCall(call: () => apiClient.logout(token));
  }
}
