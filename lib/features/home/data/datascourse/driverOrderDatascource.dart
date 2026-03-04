import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';

abstract class DriverOrderDataSource {
  Future<ApiResult<OrderResponse>> getPendingOrders(String token);
  Future<ApiResult<EditProfileResponse>> getProfile(String token);
}
