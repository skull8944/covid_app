import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunningDetail extends StatefulWidget {
  const RunningDetail({ Key? key }) : super(key: key);

  @override
  _RunningDetailState createState() => _RunningDetailState();
}

class _RunningDetailState extends State<RunningDetail> {

  bool _isRunning = false;
  bool _openMap = false;

  Position? _position;
  Position? _position_old;
  Position? _initialPosition;

  //繪圖
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 0;
  PolylineId? selectedPolyline;

  // Completer<GoogleMapController> _mapControllerCompleter = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMapController? _mapController;  

  Future<void> getInitialPosition() async {
    _initialPosition = await Geolocator.getCurrentPosition();
    _position = _initialPosition;
    _position_old = _initialPosition;
  }

  void _addMarker(var id, Position pos) {
    final MarkerId markerId = MarkerId(id);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(pos.latitude, pos.longitude),
      infoWindow: InfoWindow(title: id, snippet: '*'),
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  void _onMarkerTapped(MarkerId id) {}

  //繪圖
  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    points.add(LatLng(_position_old!.latitude,_position_old!.longitude));
    points.add(LatLng(_position!.latitude, _position!.longitude));
    _position_old=_position;
    return points;
  }

  @override
  void initState() {
    super.initState();
    _position = null;
    getInitialPosition();
    // Use this static method to start listening to a stream with position updates
    Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best,
      distanceFilter: 0,
      forceAndroidLocationManager: false,
      intervalDuration: Duration(milliseconds: 1000),
    ).listen((position) {
      _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(zoom: 14, target: LatLng(position.latitude, position.longitude))));
      //加上paint
      final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
      _polylineIdCounter++;
      final PolylineId polylineId = PolylineId(polylineIdVal);
      if(mounted) {
        setState(() {
          _position = position;
        });
      }
      final Polyline polyline = Polyline(
        polylineId: polylineId,
        consumeTapEvents: false,
        color: Colors.orange,
        width: 5,
        points: _createPoints(),
      );
      for(var item in polyline.points) {
        print(item);
      }
      if(mounted) {
        setState(() {
          polylines[polylineId] = polyline;
        });  
      }    
    });
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
                        setState(() {
                          _openMap = !_openMap;
                        });
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => Run(marks: [],)));
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
                    child: _position == null
                    ? Center(
                      child: CircularProgressIndicator(color: Colors.grey[500],)
                    )
                    : GoogleMap(
                      mapType: MapType.normal,
                      markers: Set<Marker>.of(markers.values),
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_position!.latitude, _position!.longitude),
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
                          Text('13m', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
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
                        Text('06:12', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
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
                        Icons.pause_rounded, 
                        color: Colors.grey[600],
                        size: 45,
                      ),
                      onTap: () {

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