import 'package:flutter/material.dart';
import 'package:covid_app/services/covid_info_service.dart';
import 'package:covid_app/models/covid_info.dart';
import 'package:covid_app/screens/loading.dart';

class Covid extends StatefulWidget {
  const Covid({ Key? key }) : super(key: key);

  @override
  _CovidState createState() => _CovidState();
}

class _CovidState extends State<Covid> {

  CovidInfoService _covidInfoService = CovidInfoService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CovidInfo?>(
      future: _covidInfoService.getCovidInfo(),
      builder: (BuildContext context, AsyncSnapshot<CovidInfo?> snapshot) {
        return snapshot.connectionState == ConnectionState.done 
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '日期: ' + snapshot.data!.date, 
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
              SizedBox(height:15.0),
              Text(
                '總確診數: ' + snapshot.data!.totalConfirmed, 
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
              SizedBox(height:15.0),
              Text(
                '新增確診數: ' + snapshot.data!.newConfirmed, 
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
              SizedBox(height:15.0),
              Text(
                '總死亡數: ' + snapshot.data!.totalDeath, 
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
              SizedBox(height:15.0),
              Text(
                '新增死亡數: ' + snapshot.data!.newDeath, 
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
            ],
          ),
        )
        : Loading();
      }
    );
  }
}