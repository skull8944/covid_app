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
  CovidInfo _covidInfo = CovidInfo('無法取得資料', '無法取得資料', '無法取得資料', '無法取得資料', '無法取得資料', '無法取得資料', '無法取得資料', '無法取得資料', '無法取得資料');
  bool circle = true;

  void _getCovidInfo() async {
    _covidInfo = await _covidInfoService.getCovidInfo();
    if(mounted) {
      setState(() {
        if(_covidInfo != null) {
          circle = false;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCovidInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton.icon(
            icon: Icon(Icons.refresh, color: Colors.grey[700], size: 30.0,),
            label: Container(),
            onPressed: () async {
              setState(() {
                circle = true;
              });
              await Future.delayed(Duration(seconds: 1));
              _getCovidInfo(); 
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: circle
        ? Loading()
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "日期: ${_covidInfo.date}",
              style: TextStyle(
                fontSize: 25.0
              ),
            ),
            SizedBox(height:15.0),
            Text(
              "累計確診: ${_covidInfo.totalConfirmed}", 
              style: TextStyle(
                fontSize: 25.0
              ),
            ),
            SizedBox(height:15.0),
            Text(
              "本土病例: ${_covidInfo.localConfirmed}", 
              style: TextStyle(
                fontSize: 25.0
              ),
            ),
            SizedBox(height:15.0),
            Text(
              "新增確診: ${_covidInfo.newTotalConfirmed}", 
              style: TextStyle(
                fontSize: 25.0
              ),
            ),
            SizedBox(height:15.0),
            Text(
              "新增本土病例: ${_covidInfo.newLocalConfirmed}", 
              style: TextStyle(
                fontSize: 25.0
              ),
            ),
            SizedBox(height:15.0),
            Text(
              "總死亡數: ${_covidInfo.totalDeath}", 
              style: TextStyle(
                fontSize: 25.0
              ),
            ),
            SizedBox(height:15.0),
            Text(
              "新增死亡數: ${_covidInfo.newDeath}", 
              style: TextStyle(
                fontSize: 25.0
              ),
            ),
            SizedBox(height:15.0),
            Text(
              "台灣疫苗總接種數: ${_covidInfo.injection}", 
              style: TextStyle(
                fontSize: 25.0
              ),
            ),
            SizedBox(height:15.0),
            Text(
              "新增疫苗接種數: ${_covidInfo.newInjection}", 
              style: TextStyle(
                fontSize: 25.0
              ),
            ),
          ],
        ),
      ),
    );
  }
}