import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/profile/data/models/responses/edit_profile_response.dart';
import 'package:tracking_app/features/profile/domain/repo/profile_repo.dart';

@injectable
class GetProfileUsecase {
  final ProfileRepo repository;
  GetProfileUsecase(this.repository);

  Future<ApiResult<EditProfileResponse>> call({required String token}) async {
    return await repository.getProfile(token: token);
  }
}
