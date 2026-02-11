
import '../../../../app/core/network/api_result.dart';
import '../models/response/country_model.dart';
import '../models/response/vehicles_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResult<VehiclesResponse>> getAllVehicle();
  Future<List<CountryModel>> getCountries();

// Future<ApiResult<SignupDto>> signUp({
  //   String? firstName,
  //   String? lastName,
  //   String? email,
  //   String? password,
  //   String? rePassword,
  //   String? phone,
  //   String? gender,
  // });


}
