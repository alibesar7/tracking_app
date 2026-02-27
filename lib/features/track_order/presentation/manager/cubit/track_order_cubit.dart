import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
import 'package:tracking_app/features/track_order/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/track_order/domain/usecases/track_order_usecase.dart';
import 'package:tracking_app/features/track_order/domain/usecases/driver_usecase.dart';
import 'package:tracking_app/features/track_order/domain/repos/track_order_repo.dart';

part 'track_order_state.dart';

@injectable
class TrackOrderCubit extends Cubit<TrackOrderState> {
  final TrackOrderUseCase trackOrderUseCase;
  final TrackDriverUseCase driverUseCase;
  final AuthStorage authStorage;

  StreamSubscription<List<OrderEntity>>? _ordersSubscription;
  StreamSubscription<DriverEntity>? _driverSubscription;

  TrackOrderCubit(this.trackOrderUseCase, this.driverUseCase, this.authStorage)
    : super(const TrackOrderState());

  Future<void> loadUserOrders() async {
    emit(state.copyWith(isLoading: true, error: null));

    final token = await authStorage.getToken();
    print('DEBUG: loadUserOrders called with string length: ${token?.length}');

    if (token == null) {
      emit(state.copyWith(isLoading: false, error: "User not logged in"));
      return;
    }

    String userId;
    try {
      final parts = token.split('.');
      if (parts.length != 3) throw Exception('Invalid token');
      String payload = parts[1];
      payload = payload.replaceAll('-', '+').replaceAll('_', '/');
      switch (payload.length % 4) {
        case 0:
          break;
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
        default:
          throw Exception('Illegal base64url string!');
      }
      final decoded = utf8.decode(base64Decode(payload));
      final Map<String, dynamic> data = jsonDecode(decoded);
      userId =
          data['userId'] ??
          data['id'] ??
          data['user'] ??
          data['driver'] ??
          token;
      print('DEBUG: Decoded ID from payload: $userId');
    } catch (e) {
      print('DEBUG: Token decode error: $e');
      userId = token;
    }

    final result = trackOrderUseCase(userId);

    if (result is SuccessApiResult<Stream<List<OrderEntity>>>) {
      print('DEBUG: Successfully subscribed to track orders stream');
      _ordersSubscription = result.data.listen(
        (orders) {
          print(
            'DEBUG: Stream emitted new orders list. Count: ${orders.length}',
          );
          emit(state.copyWith(orders: orders, isLoading: false, error: null));
        },
        onError: (error) {
          print('DEBUG: Stream error: $error');
          emit(state.copyWith(isLoading: false, error: error.toString()));
        },
      );
    } else if (result is ErrorApiResult<Stream<List<OrderEntity>>>) {
      print('DEBUG: ApiResult Error: ${result.error}');
      emit(state.copyWith(isLoading: false, error: result.error));
    }
  }

  void trackDriver(String driverId) {
    final result = driverUseCase(driverId);

    if (result is SuccessApiResult<Stream<DriverEntity>>) {
      _driverSubscription = result.data.listen(
        (driver) => emit(state.copyWith(driver: driver)),
        onError: (error) => emit(state.copyWith(error: error.toString())),
      );
    }
  }

  @override
  Future<void> close() async {
    await _ordersSubscription?.cancel();
    await _driverSubscription?.cancel();
    return super.close();
  }
}
