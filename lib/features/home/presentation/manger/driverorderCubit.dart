import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart' hide Order;
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/home/domain/usecase/getdriverOrderUsecase.dart';
import 'package:tracking_app/features/home/presentation/manger/driverorderIntent.dart';
import 'package:tracking_app/features/home/presentation/manger/driverorderStates.dart';
import 'package:tracking_app/features/home/domain/repo/driverOrderRepo.dart';
import 'package:tracking_app/features/home/domain/usecase/upload_driver_fire_data_use_case.dart';
import 'package:tracking_app/features/home/domain/usecase/upload_order_fire_data_use_case.dart';

@injectable
class DriverOrderCubit extends Cubit<DriverOrderState> {
  final GetDriverOrdersUseCase _getDriverOrdersUseCase;
  final AuthStorage _authStorage;
  final UploadDriverFireDataUseCase _uploadDriverFireDataUseCase;
  final UploadOrderFireDataUseCase _uploadOrderFireDataUseCase;
  final DriverOrderRepo _driverOrderRepository;

  DriverOrderCubit(
    this._getDriverOrdersUseCase,
    this._authStorage,
    this._uploadDriverFireDataUseCase,
    this._uploadOrderFireDataUseCase,
    this._driverOrderRepository,
  ) : super(DriverOrderState());

  void onIntent(DriverOrderIntent intent) {
    switch (intent) {
      case GetPendingOrders():
        _getPendingOrders();
      case RemoveOrder(order: final order):
        _removeOrder(order);
      case AcceptOrder(order: final order):
        _acceptOrder(order);
    }
  }

  void _removeOrder(Order order) {
    final currentResource = state.orderResource;
    if (currentResource.status == Status.success &&
        currentResource.data != null) {
      final currentOrders = currentResource.data!.orders!;
      final updatedOrders = currentOrders
          .where((element) => element != order)
          .toList();
      emit(
        state.copyWith(
          orderResource: Resource.success(
            currentResource.data!.copyWith(orders: updatedOrders),
          ),
        ),
      );
    }
  }

  Future<void> _acceptOrder(Order order) async {
    final token = await _authStorage.getToken();
    if (token == null) return;

    final result = await _driverOrderRepository.getProfile(token);

    if (result is SuccessApiResult) {
      final profile = (result as SuccessApiResult).data;
      if (profile.driver != null) {
        try {
          final position = await _determinePosition();
          if (position == null) {
            if (kDebugMode)
              print("Location permission denied or service disabled.");
            return;
          }

          final deviceToken = await FirebaseMessaging.instance.getToken();
          await _uploadDriverFireDataUseCase(
            profile.driver!,
            lat: position.latitude,
            lng: position.longitude,
            deviceToken: deviceToken,
          );

          await _uploadOrderFireDataUseCase(
            order: order,
            driverId: profile.driver?.Id ?? '',
          );

          if (order.id != null) {
            await _authStorage.saveOrderId(order.id!);
          }
        } catch (e) {
          if (kDebugMode) {
            print("Firestore/Location Error: $e");
          }
        }
      }
    }
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getPendingOrders() async {
    emit(state.copyWith(orderResource: Resource.loading()));
    final token = await _authStorage.getToken();
    if (token == null) {
      emit(
        state.copyWith(orderResource: Resource.error("User not authenticated")),
      );
      return;
    }
    final result = await _getDriverOrdersUseCase(token);
    return switch (result) {
      SuccessApiResult(data: final orderResponse) => emit(
        state.copyWith(orderResource: Resource.success(orderResponse)),
      ),
      ErrorApiResult(error: final error) => emit(
        state.copyWith(orderResource: Resource.error(error)),
      ),
    };
  }
}
