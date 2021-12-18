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
  int runRecordsLength = 5;
  bool circle = true;

  void getRunRecords() async {
    print('get');
    setState(() {
      circle = true;
    });
    List<RunRecord> runRecords = await _geolocatorService.getRunRecords();
    print(runRecords);
    if(runRecords.length > 0) {
      if(mounted) {
        setState(() {
          runRecordsList  = runRecords;
          runRecordsLength = runRecordsList.length;
          circle = false;
        });
      }
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
  }

  @override
  void initState() {
    super.initState();
    getRunRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: /*circle
      ? Center(child: CircularProgressIndicator())
      :*/ Container(
        height: MediaQuery.of(context).size.height * 0.78,
        child: RefreshIndicator(
          onRefresh: refreshRecords,
          child: ListView.builder(
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
          ),
        ),
      ),
    );
  }
}