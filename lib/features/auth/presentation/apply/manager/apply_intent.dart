import 'package:tracking_app/features/auth/data/models/request/apply_request_model.dart';

abstract class ApplyIntent {}

class GetCountriesIntent extends ApplyIntent {}

class GetVehiclesIntent extends ApplyIntent {}

class SubmitApplyIntent extends ApplyIntent {
  final ApplyRequestModel applyRequestModel;
  SubmitApplyIntent(this.applyRequestModel);
}
