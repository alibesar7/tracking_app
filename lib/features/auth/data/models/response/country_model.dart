import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/country_entity.dart';

part 'country_model.g.dart';

@JsonSerializable()
class CountryModel extends CountryEntity {
  const CountryModel({super.name,
    super.flag,
    super.phoneCode,
    super.isoCode});

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CountryModelToJson(this);
}
