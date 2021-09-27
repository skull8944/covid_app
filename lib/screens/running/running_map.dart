import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: InkWell(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: 150,
              height: 50,
              color: Color.fromARGB(255, 246, 195, 100),
              child: Center(child: Text('Run', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),)),
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Loading()));
          },
        ),
        /*FutureBuilder<Position?>(
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
      ),*/
    ));
  }
}