import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:covid_app/screens/running/running_detail.dart';

class RunningMap extends StatefulWidget {
  const RunningMap({ Key? key }) : super(key: key);

  @override
  _RunningMapState createState() => _RunningMapState();
}

class _RunningMapState extends State<RunningMap> {
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
            showModalBottomSheet(
              enableDrag: false,
              isScrollControlled: true,
              isDismissible: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))
              ),
              context: context, 
              builder: (BuildContext context) {
                return RunningDetail();
              }
            );
          },
        ),        
      )
    );
  }
}