import 'package:injectable/injectable.dart';
import '../../../../app/core/network/api_result.dart';
import '../../data/models/request/apply_request_model.dart';
import '../../data/models/response/apply_response_model.dart';
import '../repos/auth_repo.dart';

@lazySingleton
class ApplyUseCase {
  final AuthRepo repo;

  ApplyUseCase(this.repo);

  Future<ApiResult<ApplyResponseModel>> call(
    ApplyRequestModel applyRequestModel,
  ) {
    return repo.apply(applyRequestModel);
  }
}
