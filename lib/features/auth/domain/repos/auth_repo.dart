import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';

abstract class AuthRepo {
  Future<ApiResult<LoginResponse>> login(String email, String password);
}
