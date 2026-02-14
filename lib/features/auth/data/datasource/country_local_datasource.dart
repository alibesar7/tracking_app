import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import '../models/response/country_model.dart';

abstract class CountryLocalDataSource {
  Future<List<CountryModel>> getCountries();
}

@LazySingleton(as: CountryLocalDataSource)
class CountryLocalDataSourceImpl implements CountryLocalDataSource {
  @override
  Future<List<CountryModel>> getCountries() async {
    final String response = await rootBundle.loadString(
      'assets/data/country.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => CountryModel.fromJson(json)).toList();
  }
}
