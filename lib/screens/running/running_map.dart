import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:covid_app/services/geolocator_service.dart';
import 'dart:async';

class RunningMap extends StatefulWidget {

  final Position? initialPosition;
  RunningMap(this.initialPosition);

  @override
  _CovidMapState createState() => _CovidMapState();
}

class _CovidMapState extends State<RunningMap> {

  final geoService = GeolocatorService();
  Completer<GoogleMapController> _controller = Completer();

  Future<void> centerScreen(Position position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 18.0)
      )
    );
  }

  @override
  void initState() {
    geoService.getCurrentLocation().listen((position) {
      centerScreen(position);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
      target: LatLng(widget.initialPosition!.latitude, widget.initialPosition!.longitude), zoom: 21.0),
      myLocationEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },      
    );
  }
}