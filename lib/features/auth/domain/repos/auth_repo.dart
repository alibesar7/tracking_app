import 'package:tracking_app/features/auth/data/models/response/vechicles_entity.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicles_response_model.dart';
import 'package:tracking_app/features/auth/data/models/request/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_response_model.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:tracking_app/features/auth/domain/models/change_password_model.dart';
import '../../../../app/core/network/api_result.dart';
import '../../data/models/response/vehicle_model.dart';
import '../entities/country_entity.dart';

abstract class AuthRepo {
  Future<ApiResult<List<VehicleModel>>> getAllVehicles();
  Future<ApiResult<List<CountryEntity>>> getCountries();
  Future<ApiResult<ApplyResponseModel>> apply(
    ApplyRequestModel applyRequestModel,
  );
  Future<ApiResult<LoginResponse>> login(String email, String password);

  Future<ApiResult<ChangePasswordModel>> changePassword({
    String? password,
    String? newPassword,
  });
}
