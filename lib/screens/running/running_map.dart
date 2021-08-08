import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:covid_app/services/geolocator_service.dart';
import 'dart:async';
import 'package:covid_app/screens/home/loading.dart';

class RunningMap extends StatefulWidget {
  @override
  _CovidMapState createState() => _CovidMapState();
}

class _CovidMapState extends State<RunningMap> {

  MarkerId _start = MarkerId('start');

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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[700]),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Running Map', style: TextStyle(color: Colors.grey[700]),),
      ),
      body: FutureBuilder<Position?>(
        future: geoService.getInitialLocation(),
        builder: (BuildContext context, AsyncSnapshot<Position?> snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
            ? Loading()
            : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(snapshot.data!.latitude, snapshot.data!.longitude), zoom: 18.0
              ),
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },      
              markers: {
                Marker(position: LatLng(snapshot.data!.latitude, snapshot.data!.longitude), markerId: _start,),
              },
            );
          },
        ),
    );
  }
}