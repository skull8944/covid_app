import 'package:flutter/material.dart';
import 'package:covid_app/screens/running/running_map.dart';
import 'package:covid_app/services/geolocator_service.dart';

class Running extends StatefulWidget {

  @override
  _RunningState createState() => _RunningState();
}

class _RunningState extends State<Running> {

  final geoService = GeolocatorService();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => RunningMap()));
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