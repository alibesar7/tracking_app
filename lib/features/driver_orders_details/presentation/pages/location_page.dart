import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_marker_widgets/google_maps_marker_widgets.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/widgets/custom_marker_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final MarkerWidgetsController _controller = MarkerWidgetsController();

  final LatLng myLocation = LatLng(31.2515108, 29.9842777);
  final LatLng destination = LatLng(31.1923215, 29.9162657);

  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _addMarkers();
    _getRealRoute();
  }

  Future<void> _getRealRoute() async {
    final url =
        'https://router.project-osrm.org/route/v1/driving/${myLocation.longitude},${myLocation.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=polyline';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['code'] == 'Ok') {
        String encodedPolyline = data['routes'][0]['geometry'];

        List<PointLatLng> result = PolylinePoints.decodePolyline(
          encodedPolyline,
        );

        List<LatLng> polylineCoordinates = result
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        setState(() {
          polylines = {
            Polyline(
              polylineId: const PolylineId("real_route"),
              color: Colors.pink,
              width: 5,
              points: polylineCoordinates,
            ),
          };
        });
      }
    }
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
