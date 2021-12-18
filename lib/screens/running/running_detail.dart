import 'dart:async';

import 'package:covid_app/services/geolocator_service.dart';
import 'package:covid_app/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class RunningDetail extends StatefulWidget {
  const RunningDetail({ Key? key }) : super(key: key);

  @override
  _RunningDetailState createState() => _RunningDetailState();
}

class _RunningDetailState extends State<RunningDetail> {

  bool _isRunning = true;
  bool _openMap = false;
  bool _isPaused = false;
  double distance = 0;
  int _tick = 1;
  int time = 0;
  int marksLength = 0;
  double weight = 0;

  //繪圖
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 0;
  PolylineId? selectedPolyline;

  // Completer<GoogleMapController> _mapControllerCompleter = Completer();
  GoogleMapController? _mapController;  
  StreamSubscription<Position>? _getPositionStream;
  List<LatLng> marks = [];
  ProfileService _profileService = ProfileService();
  GeolocatorService _geolocatorService = GeolocatorService();
  Timer? _timer;

  void getWeight() async {
    final res = await _profileService.getPro();
    setState(() {
      weight = double.parse(res.weight);
    });
    print(weight);
  }

  @override
  void initState() {
    super.initState();
    _getPositionStream = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 0,
      forceAndroidLocationManager: false,
      intervalDuration: Duration(seconds: 3),
    ).listen((position) {
      _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(zoom: 14, target: LatLng(position.latitude, position.longitude))));
      final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
      _polylineIdCounter++;
      final PolylineId polylineId = PolylineId(polylineIdVal);
      marks.add(LatLng(position.latitude, position.longitude));
      setState(() {
        marksLength = marks.length;
      });
      if(marks.length > 2) {
        setState(() {
          distance += Geolocator.distanceBetween(
            marks[marks.length-2].latitude, marks[marks.length-2].longitude, 
            marks[marks.length-1].latitude, marks[marks.length-1].longitude
          );
        });
      }
      final Polyline polyline = Polyline(
        polylineId: polylineId,
        consumeTapEvents: false,
        color: Color.fromARGB(255, 246, 195, 100),
        width: 5,
        points: marks,
      );
      if(mounted) {
        setState(() {
          polylines[polylineId] = polyline;
        });  
      }    
    });
    _timer = Timer.periodic(Duration(seconds:1), (timer) { 
      setState(() {
        time += _tick;
      });      
    });    
    getWeight();
  }

  double getCalories(double weight, double distance) {
    return weight*(distance/1000)*1.036;
  }
  
  @override
  void dispose() async {
    super.dispose();
     _getPositionStream!.cancel();
     _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20)
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.grey[600],
                        size: 35,
                      ),
                      onTap: () {
                        if(_openMap == true)
                          _mapController!.dispose();
                        setState(() {
                          _openMap = !_openMap;
                        });
                      },
                    ),
                  ),
                  _isRunning
                  ? SizedBox(width: 0, height: 0,)
                  : Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.grey[600],
                        size: 35,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.48,
              child: Center(
                child: _openMap
                  ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(255, 246, 195, 100),width: 5)
                    ),
                    child: marksLength == 0
                    ? Center(
                      child: CircularProgressIndicator(color: Colors.grey[500],)
                    )
                    : GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(marks[0].latitude, marks[0].longitude),
                        zoom: 14,
                      ),
                      polylines: Set<Polyline>.of(polylines.values),
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                      },
                    ),
                  )
                  : Image.asset('./assets/img/logo.png', scale: 11,)
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text((distance/1000).toStringAsFixed(2)+'km', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
                          Text('距離', style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),),
                        ],
                      )
                    ),
                  ),
                  Container(
                    height: 75,
                    width: MediaQuery.of(context).size.width * 0.05,
                    child: VerticalDivider(color: Colors.grey[700], thickness: 4,)
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(time.toString(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
                        Text('時間', style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),),
                      ],
                    )
                  ),
                  Container(
                    height: 75,
                    width: MediaQuery.of(context).size.width * 0.05,
                    child: VerticalDivider(color: Colors.grey[700], thickness: 4,)
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('132', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
                        Text('卡路里', style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),),
                      ],
                    )
                  ),                
                ],
              ),
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Icon(
                        _isPaused 
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded,
                        color: Colors.grey[600],
                        size: 45,
                      ),
                      onTap: () {
                        if(_getPositionStream!.isPaused) {
                          _getPositionStream!.resume();
                          setState(() {
                            _tick = 1;
                          });
                        } else{
                         _getPositionStream!.pause();
                          setState(() {
                            _tick = 0;
                          });
                        }                      
                        setState(() {
                          _isPaused = !_isPaused;
                        });
                      },
                    ),
                    InkWell(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Color.fromARGB(255, 246, 195, 100),
                        child: Text(
                          '13:23',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 28,
                            color: Colors.white
                          ),
                        ),
                      ),
                      onTap: () {

                      },
                    ),
                    InkWell(
                      child: Icon(
                        Icons.stop_outlined,
                        color: Colors.grey[600],
                        size: 45,
                      ),
                      onTap: () async {
                        if(distance > 0) {
                          final res = await _geolocatorService.saveRecord(
                            (distance/1000).toStringAsFixed(2), 
                            time.toString(), 
                            getCalories(weight, distance).toStringAsFixed(2), 
                            marks
                          );
                          print('res: '+res);
                          if(res == 'success') {
                            Navigator.pop(context);
                          } else {
                            showDialog(
                            context: context, 
                            builder: (BuildContext context) => Center(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.1,      
                                width: MediaQuery.of(context).size.width * 0.35,                
                                child: Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  insetPadding: EdgeInsets.zero,
                                  child: Center(
                                    child: Text(
                                      '儲存失敗', 
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 28,
                                        color: Colors.red
                                      ),
                                    ),
                                  )
                                ),
                              ),
                            ),
                          );
                          }                        
                        } else {
                          showDialog(
                            context: context, 
                            builder: (BuildContext context) => Center(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.1,      
                                width: MediaQuery.of(context).size.width * 0.35,                
                                child: Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  insetPadding: EdgeInsets.zero,
                                  child: Center(
                                    child: Text(
                                      '請跑步', 
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 28,
                                        color: Colors.red
                                      ),
                                    ),
                                  )
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        )
      )
    );
  }
}