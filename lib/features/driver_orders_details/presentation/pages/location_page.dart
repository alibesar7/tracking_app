import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_marker_widgets/google_maps_marker_widgets.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/widgets/custom_marker_widget.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final MarkerWidgetsController _controller = MarkerWidgetsController();

  final LatLng myLocation = LatLng(31.2515108, 29.9842777);
  final LatLng destination = LatLng(31.1923215, 29.9162657);

  Set<Polyline> polylines = {
    Polyline(
      polylineId: PolylineId("route"),
      points: [LatLng(31.2515108, 29.9842777), LatLng(31.1923215, 29.9162657)],
      color: Colors.pink,
      width: 2,
    ),
  };
  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  void _addMarkers() {
    _controller.addMarkerWidget(
      markerWidget: MarkerWidget(
        markerId: const MarkerId("driver_location"),
        child: customMarker(
          "Your location",
          const Icon(
            Icons.location_on_outlined,
            color: AppColors.pink,
            size: 20,
          ),
        ),
      ),
      marker: Marker(
        markerId: const MarkerId("driver_location"),
        position: myLocation,
      ),
    );

    _controller.addMarkerWidget(
      markerWidget: MarkerWidget(
        markerId: const MarkerId("user_location"),
        child: customMarker(
          "User",
          const Icon(Icons.home_outlined, color: AppColors.pink, size: 20),
        ),
      ),
      marker: Marker(
        markerId: const MarkerId("user_location"),
        position: destination,
      ),
    );
  }

  CameraPosition routeCameraPosition = const CameraPosition(
    target: LatLng(31.2515108, 29.9842777),
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location')),
      body: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: MarkerWidgets(
                markerWidgetsController: _controller,
                builder: (BuildContext context, Set<Marker> markers) {
                  return GoogleMap(
                    initialCameraPosition: routeCameraPosition,
                    mapType: MapType.normal,
                    markers: markers,
                    polylines: polylines,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
