import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:covid_app/models/run_record.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GeolocatorService {

  final String host = 'http://172.20.10.13:7414';
  
  //算距離：每兩個點算加上去，for(var i = 0; i < n -1; i++) { a[i] + a[i+1] }
  double? calculateDistance(List<Position> list) {
    double total = 0;
    for(var i = 0; i < list.length -1 ; i++) {
      total += Geolocator.distanceBetween(list[i].latitude, list[i].longitude, list[i+1].latitude, list[i+1].longitude);
    }
    return total;
  }

  Future saveRecord(String distance, String time, String calories, List marks) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String userName = _prefs.getString('name').toString();
    final res = await http.post(Uri.parse('$host/run'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8'
      },
      body: jsonEncode({
        'userName': userName,
        'distance': distance,
        'time': time,
        'calories': calories,
        'marks': marks
      }));
    print(res.statusCode);
    if(res.statusCode == 200 || res.statusCode == 201) {
      return 'success';
    } else {
      return 'error';
    }          
    
  }

  Future<List<RunRecord>> getRunRecords() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String userName = _prefs.getString('name').toString();
    List<RunRecord> records = [];
    final  res = await http.Client().get(Uri.parse('$host/run/$userName'));
    if(res.statusCode == 200 || res.statusCode == 201) {
      List result = jsonDecode(res.body);
      result.forEach((e) {
        List rec = e['marks'];
        List<LatLng> marks = [];
  
        for(var i = 0; i < rec.length; i++) {
          marks.add(LatLng(rec[i][0],rec[i][1]));
        }
        records.add(
          RunRecord(
            e['_id'], 
            e['created_at'], 
            e['distance'], 
            e['time'], 
            e['calories'], 
            marks
          )
        );
      });
    }
    print(records[0].marks);
    return records;
  }

  Future deleteRecord(String recordID) async {
    final res = await http.delete(Uri.parse('$host/run/$recordID'));
    return res.body;
  }
    
  Future<List<LatLng>> getMarks(String runRecordID) async {
    List<LatLng> marks = [];
    final res = await http.Client().get(Uri.parse('$host/run/marks/$runRecordID'));
    if(res.statusCode == 200 || res.statusCode == 201) {
      List result = jsonDecode(res.body);
      result.forEach((e) { 
        marks.add(
          LatLng(e[0], e[1])
        );
      });
    }
    return marks;
  }
}