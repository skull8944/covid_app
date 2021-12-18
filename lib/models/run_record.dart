import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunRecord {

  String runRecordID;
  String date;
  String distance;
  String time;
  String calories;
  List<LatLng> marks;

  RunRecord(
    this.runRecordID,
    this.date, 
    this.distance, 
    this.time, 
    this.calories,
    this.marks
  );
}