import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class RunningRecord extends StatefulWidget {
  const RunningRecord({ Key? key }) : super(key: key);

  @override
  _RunningRecordState createState() => _RunningRecordState();
}

class _RunningRecordState extends State<RunningRecord> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.78,
        child: ListView.builder(
          itemCount: 5,
          itemBuilder:(BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: DottedLine(
                        dashLength: 14,
                        dashGapLength: 14,
                        lineThickness: 7,
                        dashRadius: 14,
                        dashColor: Color.fromARGB(255, 246, 195, 100),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.28,
                          padding: EdgeInsets.all(14),
                          color: Color.fromARGB(255, 246, 195, 100),
                          child: Center(child: Text('Today', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 23,),))
                        ),
                      ),
                    ),
                    Expanded(
                      child: DottedLine(
                        dashLength: 14,
                        dashGapLength: 14,
                        lineThickness: 7,
                        dashRadius: 14,
                        dashColor: Color.fromARGB(255, 246, 195, 100),
                      )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.28,
                      child: Center(
                        child: Column(
                          children: [
                            Text('13m', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
                            Text('Distance', style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),),
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
                        children: [
                          Text('06:12', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
                          Text('Pace', style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),),
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
                        children: [
                          Text('132', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
                          Text('Calories', style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),),
                        ],
                      )
                    )
                  ],
                ),
              ],
            );            
          }          
        ),
      ),
    );
  }
}