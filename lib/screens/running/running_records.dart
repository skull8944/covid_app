import 'package:covid_app/models/run_record.dart';
import 'package:covid_app/screens/running/running_record_view.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/services/geolocator_service.dart';

class RunningRecord extends StatefulWidget {
  const RunningRecord({ Key? key }) : super(key: key);

  @override
  _RunningRecordState createState() => _RunningRecordState();
}

class _RunningRecordState extends State<RunningRecord> {

  GeolocatorService _geolocatorService = GeolocatorService();
  List<RunRecord> runRecordsList = [];
  int runRecordsLength = 0;
  bool circle = true;

  void getRunRecords() async {
    setState(() {
      circle = true;
    });
    List<RunRecord> runRecords = await _geolocatorService.getRunRecords();
    if(runRecords.length > 0) {
      if(mounted) {
        setState(() {
          runRecordsList  = runRecords;
          runRecordsLength = runRecordsList.length;
        });
      }
    }
    if(mounted) {
      setState(() {      
        circle = false;
      });
    }    
  }

  Future<void> refreshRecords() async {
    List<RunRecord> runRecords = await _geolocatorService.getRunRecords();
    
    if(runRecords.length > 0) {
      setState(() {
        runRecordsList.clear();
        runRecordsList = runRecords;
        runRecordsLength = runRecordsList.length;
      });
    }
    setState(() {      
      circle = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getRunRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: circle
      ? Center(child: CircularProgressIndicator())
      : Container(
        height: MediaQuery.of(context).size.height * 0.78,
        child: RefreshIndicator(
          onRefresh: refreshRecords,
          child: runRecordsLength > 0
          ? ListView.builder(
            itemCount: runRecordsLength,
            itemBuilder:(BuildContext context, int index) {
              return RunningRecordView(
                runRecord: runRecordsList[index],
                deleteRecord: (String runRecordID) {
                  runRecordsList.removeWhere((item) => item.runRecordID == runRecordID);
                  setState(() {
                    runRecordsLength--;
                  });
                },
              );
            }          
          )
          : Center(
            child: Column(
              children: [
                Text(
                  '尚未有紀錄',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 28
                  ),
                ),
                InkWell(
                  child: Icon(Icons.replay_rounded, color: Colors.grey[800], size: 35,),
                  onTap: () {
                    getRunRecords();
                  },
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}