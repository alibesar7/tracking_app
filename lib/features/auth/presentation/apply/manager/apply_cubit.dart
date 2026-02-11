import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecase/get_countries_usecase.dart';
import '../../../../../app/core/network/api_result.dart';
import 'apply_state.dart';
import '../../../domain/entities/country_entity.dart';
import '../../../domain/usecase/get_all_vehicles_usecase.dart';
import 'apply_intent.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_model.dart';

@injectable
class ApplyCubit extends Cubit<ApplyState> {
  final GetCountriesUseCase _getCountriesUseCase;
  final GetAllVehiclesUseCase _getAllVehiclesUseCase;

  ApplyCubit(this._getCountriesUseCase, this._getAllVehiclesUseCase)
    : super(const ApplyState());

  Future<void> onIntent(ApplyIntent intent) async {
    if (intent is GetCountriesIntent) {
      await _getCountries();
    } else if (intent is GetVehiclesIntent) {
      await _getVehicles();
    }
  }

  Future<void> _getCountries() async {
    emit(state.copyWith(status: ApplyStatus.loading));
    final result = await _getCountriesUseCase();

    if (result is SuccessApiResult<List<CountryEntity>>) {
      emit(state.copyWith(status: ApplyStatus.success, countries: result.data));
    } else if (result is ErrorApiResult<List<CountryEntity>>) {
      emit(
        state.copyWith(status: ApplyStatus.failure, errorMessage: result.error),
      );
    }
  }

  Future<void> _getVehicles() async {
    emit(state.copyWith(vehiclesStatus: ApplyStatus.loading));
    final result = await _getAllVehiclesUseCase();

    if (result is SuccessApiResult<List<VehicleModel>>) {
      emit(
        state.copyWith(
          vehiclesStatus: ApplyStatus.success,
          vehicles: result.data,
        ),
      );
    } else if (result is ErrorApiResult<List<VehicleModel>>) {
      emit(
        state.copyWith(
          vehiclesStatus: ApplyStatus.failure,
          vehiclesErrorMessage: result.error,
        ),
      );
    }
  }
}
