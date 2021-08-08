import 'package:flutter/material.dart';
import 'package:covid_app/services/covid_info_service.dart';
import 'package:covid_app/models/covid_info.dart';
import 'package:covid_app/screens/home/loading.dart';

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
                "日期: ${snapshot.hasData ? snapshot.data!.date : '無法取得資料'}",
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
              SizedBox(height:15.0),
              Text(
                "累計確診: ${snapshot.hasData ? snapshot.data!.totalConfirmed : '無法取得資料'}", 
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
              SizedBox(height:15.0),
              Text(
                "本土病例: ${snapshot.hasData ? snapshot.data!.localConfirmed : '無法取得資料'}", 
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
              SizedBox(height:15.0),
              Text(
                "新增確診: ${snapshot.hasData ? snapshot.data!.newTotalConfirmed : '無法取得資料'}", 
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
              SizedBox(height:15.0),
              Text(
                "新增本土病例: ${snapshot.hasData ? snapshot.data!.newLocalConfirmed : '無法取得資料'}", 
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
              SizedBox(height:15.0),
              Text(
                "總死亡數: ${snapshot.hasData ? snapshot.data!.totalDeath : '無法取得資料'}", 
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
              SizedBox(height:15.0),
              Text(
                "新增死亡數: ${snapshot.hasData ? snapshot.data!.newDeath : '無法取得資料'}", 
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
              SizedBox(height:15.0),
              Text(
                "台灣疫苗總接種數: ${snapshot.hasData ? snapshot.data!.injection : '無法取得資料'}", 
                style: TextStyle(
                  fontSize: 25.0
                ),
              ),
              SizedBox(height:15.0),
              Text(
                "新增疫苗接種數: ${snapshot.hasData ? snapshot.data!.newInjection : '無法取得資料'}", 
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