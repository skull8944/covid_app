import 'package:flutter/material.dart';
import 'package:covid_app/screens/running/running_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:covid_app/services/geolocator_service.dart';
import 'package:covid_app/screens/loading.dart';

class Running extends StatefulWidget {

  @override
  _RunningState createState() => _RunningState();
}

class _RunningState extends State<Running> {

  final geoService = GeolocatorService();
  bool isRun = false;

  @override
  Widget build(BuildContext context) {
    return isRun 
      ? FutureBuilder<Position?>(
          future: geoService.getInitialLocation(),
          builder: (BuildContext context, AsyncSnapshot<Position?> snapshot) {
            return snapshot.connectionState == ConnectionState.done
              ? RunningMap(snapshot.data)
              : Loading();
          },
        )
      : Container(
        color: Colors.grey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [      
              Image.asset('assets/img/stopwatch.png', scale: 4.0,),
              SizedBox(height: 5.0,),
              ClipRRect(
                borderRadius: BorderRadius.circular(22.5),
                child: Container(
                  width: 95.0,
                  height: 38.0,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                    ),
                    child: Text('Run', 
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isRun = true;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 25.0,),
            ] 
          ),
        ),
      );    
  }
}