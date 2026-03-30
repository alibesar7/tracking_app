import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecase/get_countries_usecase.dart';
import '../../../../../app/core/network/api_result.dart';
import 'apply_state.dart';
import '../../../domain/entities/country_entity.dart';
import '../../../domain/usecase/get_all_vehicles_usecase.dart';
import 'apply_intent.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_model.dart';
import 'package:tracking_app/features/auth/domain/usecase/apply_usecase.dart';
import 'package:tracking_app/features/auth/data/models/request/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/response/apply_response_model.dart';

@injectable
class ApplyCubit extends Cubit<ApplyState> {
  final GetCountriesUseCase _getCountriesUseCase;
  final GetAllVehiclesUseCase _getAllVehiclesUseCase;
  final ApplyUseCase _applyUseCase;

  ApplyCubit(
    this._getCountriesUseCase,
    this._getAllVehiclesUseCase,
    this._applyUseCase,
  ) : super(const ApplyState());

  Future<void> onIntent(ApplyIntent intent) async {
    if (intent is GetCountriesIntent) {
      await _getCountries();
    } else if (intent is GetVehiclesIntent) {
      await _getVehicles();
    } else if (intent is SubmitApplyIntent) {
      await _submitApply(intent.applyRequestModel);
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

  Future<void> _submitApply(ApplyRequestModel applyRequestModel) async {
    emit(state.copyWith(applyStatus: ApplyStatus.loading));
    final result = await _applyUseCase(applyRequestModel);

    if (result is SuccessApiResult<ApplyResponseModel>) {
      emit(state.copyWith(applyStatus: ApplyStatus.success));
    } else if (result is ErrorApiResult<ApplyResponseModel>) {
      emit(
        state.copyWith(
          applyStatus: ApplyStatus.failure,
          applyErrorMessage: result.error,
        ),
      );
    }
  }
}
