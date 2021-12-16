import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunRecord {

  String recordID;
  String userName;
  String date;
  String distance;
  String time;
  String calories;
  List<LatLng> marks;

  RunRecord(
    this.recordID,
    this.userName, 
    this.date, 
    this.distance, 
    this.time, 
    this.calories,
    this.marks
  );
}