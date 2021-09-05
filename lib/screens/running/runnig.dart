import 'package:covid_app/screens/running/rounded_clipper.dart';
import 'package:covid_app/screens/running/running_records.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/screens/running/running_map.dart';
import 'package:covid_app/services/geolocator_service.dart';

class Running extends StatefulWidget {

  @override
  _RunningState createState() => _RunningState();
}

class _RunningState extends State<Running> {

  final geoService = GeolocatorService();
  int childPage = 0;
  List<Widget> childPages = [RunningMap(), RunningRecord()];

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Color.fromARGB(255, 236, 236, 239),
      child: Column(
        children: [
          Container(
            child: Stack(
              children: [
                ClipPath(
                  clipper: RoundedClipper(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.22,
                    color: Color.fromARGB(255, 246, 195, 100),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.1,
                            right: MediaQuery.of(context).size.width * 0.1,
                            top: MediaQuery.of(context).size.height * 0.017
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: Icon(Icons.directions_run_rounded, size: 50, color: Colors.white,),
                                onTap: () {
                                  setState(() {
                                    childPage = 0;
                                  });
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07),
                                child: InkWell(
                                  child: Icon(Icons.paste_rounded, size: 50, color: Colors.white,),
                                  onTap: () {
                                    setState(() {
                                      childPage = 1;
                                    });
                                  },
                                ),
                              ),
                              InkWell(
                                child: Icon(Icons.turned_in_rounded, size: 50, color: Colors.white,),
                                onTap: () {
                                  
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          IndexedStack(
            index: childPage,
            children: childPages,
          )
        ],
      ),
    );
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*Container(
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
    );  */  
  }
}