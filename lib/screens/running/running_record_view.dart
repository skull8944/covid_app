import 'package:covid_app/models/run_record.dart';
import 'package:covid_app/screens/running/running_marks.dart';
import 'package:covid_app/screens/social/add_post.dart';
import 'package:covid_app/services/geolocator_service.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RunningRecordView extends StatefulWidget {
  final RunRecord runRecord;
  final Function deleteRecord;
  const RunningRecordView({ Key? key, required this.runRecord, required this.deleteRecord }) : super(key: key);

  @override
  _RunningRecordViewState createState() => _RunningRecordViewState();
}

class _RunningRecordViewState extends State<RunningRecordView> {

  GeolocatorService _geolocatorService = GeolocatorService();

  @override
  Widget build(BuildContext context) {
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
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: EdgeInsets.all(14),
                    color: Color.fromARGB(255, 246, 195, 100),
                    child: Center(
                      child: Text(
                        '${widget.runRecord.date.substring(0,10)}',
                        style: TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.w600, 
                          fontSize: 23,
                        ),
                      )
                    )
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
                      return AddPost(
                        runRecordID: widget.runRecord.runRecordID,
                        distance: widget.runRecord.distance ,
                        time: (int.parse(widget.runRecord.time)~/60).toString() + ':' + (int.parse(widget.runRecord.time)%60).toString(),
                        calories: widget.runRecord.calories
                      );
                    }
                  )
                },
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: '路線',
                color: Colors.black45,
                icon: Icons.map_outlined,
                onTap: () {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,      
                      width: MediaQuery.of(context).size.width * 0.9,                
                      child: Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        insetPadding: EdgeInsets.zero,
                        child: RunningMarks(marks: widget.runRecord.marks,)
                      ),
                    ),
                  );
                },
              ),
              IconSlideAction(
                caption: '刪除',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () async {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) => AlertDialog(
                      content: Text(
                        '確定刪除此紀錄?', 
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                        ),
                      ),
                      actions: <Widget>[
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Text(
                              '確定',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.green
                              ),
                            )
                          ),
                          onTap: () async {
                            final res = await _geolocatorService.deleteRecord(widget.runRecord.runRecordID);
                            if(res == 'success') {
                              widget.deleteRecord(widget.runRecord.runRecordID);
                            }
                            print(res);
                            Navigator.pop(context);
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Text(
                              '取消',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.red
                              ),
                            )
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  );
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
                        Text('${widget.runRecord.distance}m', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
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
                      Text(
                        (int.parse(widget.runRecord.time)~/60).toString() 
                        + ':' 
                        + (int.parse(widget.runRecord.time)%60).toString(),
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      ),
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
                      Text('${widget.runRecord.calories}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
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
}