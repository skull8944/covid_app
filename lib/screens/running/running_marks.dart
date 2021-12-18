import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunningMarks extends StatefulWidget {
  final List<LatLng> marks;
  const RunningMarks({ Key? key, required this.marks }) : super(key: key);

  @override
  _RunningMarksState createState() => _RunningMarksState();
}

class _RunningMarksState extends State<RunningMarks> {

  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline> {};

  @override
  void initState() {
    super.initState();
    print(widget.marks);
    for(int i = 0; i < widget.marks.length; i++) { 
      final PolylineId polylineId = PolylineId('polyline_id_$i');
      final Polyline polyline = Polyline(
        polylineId: polylineId,
        consumeTapEvents: false,
        color: Colors.orange,
        width: 5,
        points: widget.marks,
      );
      if(mounted) {
        setState(() {
          polylines[polylineId] = polyline;
        });  
      }    
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white
      ),
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.marks[0].latitude, widget.marks[0].longitude),
          zoom: 14,
        ),
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }
}