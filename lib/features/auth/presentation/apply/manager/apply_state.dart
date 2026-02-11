import 'package:equatable/equatable.dart';
import '../../../domain/entities/country_entity.dart';
import 'package:tracking_app/features/auth/data/models/response/vehicle_model.dart';

enum ApplyStatus { initial, loading, success, failure }

class ApplyState extends Equatable {
  final ApplyStatus status;
  final List<CountryEntity> countries;
  final String? errorMessage;

  final ApplyStatus vehiclesStatus;
  final List<VehicleModel> vehicles;
  final String? vehiclesErrorMessage;

  const ApplyState({
    this.status = ApplyStatus.initial,
    this.countries = const [],
    this.errorMessage,
    this.vehiclesStatus = ApplyStatus.initial,
    this.vehicles = const [],
    this.vehiclesErrorMessage,
  });

  ApplyState copyWith({
    ApplyStatus? status,
    List<CountryEntity>? countries,
    String? errorMessage,
    ApplyStatus? vehiclesStatus,
    List<VehicleModel>? vehicles,
    String? vehiclesErrorMessage,
  }) {
    return ApplyState(
      status: status ?? this.status,
      countries: countries ?? this.countries,
      errorMessage: errorMessage ?? this.errorMessage,
      vehiclesStatus: vehiclesStatus ?? this.vehiclesStatus,
      vehicles: vehicles ?? this.vehicles,
      vehiclesErrorMessage: vehiclesErrorMessage ?? this.vehiclesErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    countries,
    errorMessage,
    vehiclesStatus,
    vehicles,
    vehiclesErrorMessage,
  ];
}
