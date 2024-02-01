import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(46.781946, 23.621316);
  static const LatLng destination = LatLng(47.781946, 24.621316);

  List<LatLng> polylineCoordinates = [];

  // String get google_maps_flutter => null;

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDL9Ua5sgSw5IDJQ7C7hk8vH3SqToanIvk",
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) =>
            polylineCoordinates.add(LatLng(point.latitude, point.longitude)),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Track Order",
        style: TextStyle(color: Colors.black, fontSize: 16),
      )),
      body: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          initialCameraPosition: CameraPosition(
            target: sourceLocation,
            zoom: 13.5,
          ),
          polylines: {
            Polyline(
              polylineId: PolylineId("route"),
              points: polylineCoordinates,
            )
          },
          markers: {
            Marker(
              markerId: MarkerId("source"),
              position: LatLng(46.781946, 23.621316),
            ),
            Marker(
              markerId: MarkerId("destination"),
              position: LatLng(47.781946, 24.621316),
            )
          }),
    );
  }
}
