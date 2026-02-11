import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable {
  final String? name;
  final String? flag;
  final String? phoneCode;
  final String? isoCode;

  const CountryEntity({this.name, this.flag, this.phoneCode, this.isoCode});

  @override
  List<Object?> get props => [name, flag, phoneCode, isoCode];
}
