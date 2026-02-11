
import 'package:tracking_app/features/auth/data/models/response/vechicles_entity.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicles_response_model.dart';

import '../../../../app/core/network/api_result.dart';
import '../../data/models/response/vehicle_model.dart';
import '../entities/country_entity.dart';

abstract class AuthRepo {
 // Future<ApiResult<LoginModel>> login(String email, String password);
   Future<ApiResult<List<VehicleModel>>> getAllVehicles();
   Future<ApiResult<List<CountryEntity>>> getCountries();


}

