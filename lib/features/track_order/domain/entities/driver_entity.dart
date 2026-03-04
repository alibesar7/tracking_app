import 'package:equatable/equatable.dart';

class DriverEntity extends Equatable {
  final String id;
  final double lat;
  final double lng;
  final String name;
  final String phone;
  final String deviceToken;
  final String? currentLocation;

  const DriverEntity({
    required this.id,
    required this.lat,
    required this.lng,
    required this.name,
    required this.phone,
    required this.deviceToken,
    this.currentLocation,
  });

  @override
  List<Object?> get props => [
    id,
    lat,
    lng,
    name,
    phone,
    deviceToken,
    currentLocation,
  ];
}
