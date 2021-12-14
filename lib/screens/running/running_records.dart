import 'package:covid_app/screens/social/add_post.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
            return Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: Column(
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
                  Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actions: <Widget>[
                      IconSlideAction(
                        caption: '分享',
                        color: Colors.indigo,
                        icon: Icons.share,
                        onTap: () => {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            isDismissible: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                            ),
                            context: context, 
                            builder: (BuildContext context) {
                              return AddPost(distance: '13m', time: '06:12', calories: '132',);
                            }
                          )
                        },
                      ),
                    ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: '地圖',
                        color: Colors.black45,
                        icon: Icons.more_horiz,
                        onTap: () {
                          
                        },
                      ),
                      IconSlideAction(
                        caption: '刪除',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {

                        },
                      ),
                    ],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.28,
                          child: Center(
                            child: Column(
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
                            children: [
                              Text('132', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
                              Text('卡路里', style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),),
                            ],
                          )
                        ),
                        
                      ],
                    ),
                  ),                  
                ],
              ),
            );            
          }          
        ),
      ),
    );
  }
}