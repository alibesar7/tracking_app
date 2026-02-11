import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/dio.dart';
import 'package:tracking_app/features/auth/data/models/request/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_response_model.dart';
import '../../../features/auth/data/models/response/vehicles_response_model.dart';
import '../values/app_endpoint_strings.dart';
part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio) = _ApiClient;

  @GET(AppEndpointString.getVehicles)
  Future<HttpResponse<VehiclesResponse>> getAllVehicle();
  @GET(AppEndpointString.apply)
  Future<HttpResponse<ApplyResponseModel>> apply(@Body() ApplyRequestModel applyRequest);
}
