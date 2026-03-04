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
  LatLng? destination;
  final String myAddress = "City Centre Alexandria";

  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _addMyMarker();
    _setDestinationFromAddress();
  }

  void _addMyMarker() {
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
  }

  Future<void> _setDestinationFromAddress() async {
    LatLng? result = await getLatLngFromAddress(myAddress);
    if (result != null) {
      destination = result;
      _controller.addMarkerWidget(
        markerWidget: MarkerWidget(
          markerId: const MarkerId("destination_location"),
          child: customMarker(
            "Destination",
            const Icon(Icons.home_outlined, color: AppColors.pink, size: 20),
          ),
        ),
        marker: Marker(
          markerId: const MarkerId("destination_location"),
          position: result,
        ),
      );
      await _getRealRoute();
    }
  }

  Future<LatLng?> getLatLngFromAddress(String address) async {
    final url =
        "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent("$address, Egypt")}&format=json&limit=1&addressdetails=1";

    final response = await http.get(
      Uri.parse(url),
      headers: {"User-Agent": "tracking_app"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("<<<<<<<< Geocode response: $data");

      if (data.isNotEmpty) {
        double lat = double.parse(data[0]['lat']);
        double lon = double.parse(data[0]['lon']);
        return LatLng(lat, lon);
      }
    }

    return null;
  }

  Future<void> _getRealRoute() async {
    if (destination == null) return;
    final url =
        'https://router.project-osrm.org/route/v1/driving/${myLocation.longitude},${myLocation.latitude};${destination!.longitude},${destination!.latitude}?overview=full&geometries=polyline';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('<<<<<<<<< OSRM data: $data');
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
      } else {
        print("OSRM Error: ${data['code']}");
      }
    }
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
