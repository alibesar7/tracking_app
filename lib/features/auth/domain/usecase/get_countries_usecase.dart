import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import '../entities/country_entity.dart';
import '../repos/auth_repo.dart';

@injectable
class GetCountriesUseCase {
  final AuthRepo repo;

  GetCountriesUseCase(this.repo);

  Future<ApiResult<List<CountryEntity>>> call() async {
    return await repo.getCountries();
  }
}
