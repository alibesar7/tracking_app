import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/app/core/ui_helper/assets/images.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/app/core/values/paths.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/location_type.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/manager/order_details_cubit.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/manager/order_details_states.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/widgets/address_card.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/widgets/section_title.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

class LocationPage extends StatefulWidget {
  final LocationType locationType;
  const LocationPage({super.key, required this.locationType});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late OrderDetailsCubit cubit;

  LatLng? destination;
  Set<Polyline> polylines = {};

  Set<Marker> markers = {};
  BitmapDescriptor? driverIcon;
  BitmapDescriptor? destinationIcon;

  @override
  void initState() {
    super.initState();
    cubit = getIt<OrderDetailsCubit>();
    cubit.getOrderDetails();
    loadMarkerIcons();
  }

  Future<BitmapDescriptor> getMarkerIcon(String path) async {
    final ByteData data = await DefaultAssetBundle.of(context).load(path);
    final Uint8List bytes = data.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  Future<void> loadMarkerIcons() async {
    driverIcon = await getMarkerIcon(Assets.driverLocation);

    destinationIcon = await getMarkerIcon(
      widget.locationType == LocationType.pickup
          ? Assets.floweryLocation
          : Assets.userLocation,
    );
    setState(() {});
  }

  void driverMarker(LatLng driverLocation) {
    markers.removeWhere((m) => m.markerId.value == "driver_location");
    markers.add(
      Marker(
        markerId: const MarkerId("driver_location"),
        position: driverLocation,
        icon: driverIcon ?? BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: "Your location"),
      ),
    );
  }

  void destinationMarker(LatLng destinationLocation) {
    markers.add(
      Marker(
        markerId: const MarkerId("destination_location"),
        position: destinationLocation,
        icon: destinationIcon ?? BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: "Destination"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<OrderDetailsCubit>(
        create: (context) => cubit,
        child: BlocConsumer<OrderDetailsCubit, OrderDetailsStates>(
          listener: (context, state) {
            final driver = state.driverData?.data;
            final order = state.data?.data;
            if (driver == null || order == null) return;

            final driverLocation = LatLng(
              driver.currentLocation.lat,
              driver.currentLocation.lng,
            );
            String address;

            if (widget.locationType == LocationType.pickup) {
              address = order.orderDetails.pickupAddress.address;
            } else {
              address = order.userAddress.address;
            }

            print(
              '<<<<<<< driver $driver, order $order, ${state.destination}, ${state.polylines}',
            );

            cubit.setDestinationFromAddress(address, driverLocation);

            driverMarker(driverLocation);

            if (state.destination == null || state.polylines == null) return;
            destinationMarker(state.destination!);

            if (state.polylines != null) {
              polylines = {
                Polyline(
                  polylineId: const PolylineId("real_route"),
                  color: AppColors.pink,
                  width: 5,
                  points: state.polylines ?? [],
                ),
              };
            }
            setState(() {});
          },

          builder: (context, state) {
            final driver = state.driverData?.data;
            if (driver == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final driverLocation = LatLng(
              driver.currentLocation.lat,
              driver.currentLocation.lng,
            );

            return Stack(
              alignment: Alignment.topLeft,

              children: [
                Column(
                  children: [
                    Expanded(
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: driverLocation,
                          zoom: 18,
                        ),
                        mapType: MapType.normal,
                        markers: markers,
                        polylines: polylines,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.locationType == LocationType.pickup) ...[
                            SectionTitle(title: LocaleKeys.pickupAddress.tr()),
                            AddressCard(
                              title:
                                  state
                                      .data
                                      ?.data
                                      ?.orderDetails
                                      .pickupAddress
                                      .name ??
                                  '',
                              address:
                                  state
                                      .data
                                      ?.data
                                      ?.orderDetails
                                      .pickupAddress
                                      .address ??
                                  '',
                              imagePath: AppPaths.flowerLogo,
                              phoneNumber: (state.driverData?.data?.phone)
                                  .toString(),
                            ),
                            const SizedBox(height: 16),
                            SectionTitle(title: LocaleKeys.userAddress.tr()),

                            AddressCard(
                              title: state.data?.data?.userAddress.name ?? '',
                              address:
                                  state.data?.data?.userAddress.address ?? '',
                              imagePath: AppPaths.flowerLogo,
                              phoneNumber: (state.driverData?.data?.phone)
                                  .toString(),
                            ),
                          ] else ...[
                            SectionTitle(title: LocaleKeys.userAddress.tr()),
                            AddressCard(
                              title: state.data?.data?.userAddress.name ?? '',
                              address:
                                  state.data?.data?.userAddress.address ?? '',
                              imagePath: AppPaths.flowerLogo,
                              phoneNumber: (state.driverData?.data?.phone)
                                  .toString(),
                            ),
                            const SizedBox(height: 16),
                            SectionTitle(title: LocaleKeys.pickupAddress.tr()),
                            AddressCard(
                              title:
                                  state
                                      .data
                                      ?.data
                                      ?.orderDetails
                                      .pickupAddress
                                      .name ??
                                  '',
                              address:
                                  state
                                      .data
                                      ?.data
                                      ?.orderDetails
                                      .pickupAddress
                                      .address ??
                                  '',
                              imagePath: AppPaths.flowerLogo,
                              phoneNumber: (state.driverData?.data?.phone)
                                  .toString(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                Positioned(
                  top: 40,
                  left: 16,
                  child: InkWell(
                    onTap: () => context.pop(),
                    child: CircleAvatar(
                      backgroundColor: AppColors.pink,
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
