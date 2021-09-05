import 'package:covid_app/screens/covid/rounded_clipper.dart';
import 'package:covid_app/screens/covid/switch_button.dart';
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
  bool alert = false;
  int ?_toggleValue;

  void _getCovidInfo() async {
    setState(() {
      circle = true;
    });
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
      backgroundColor: Color.fromARGB(255, 236, 236, 239),
      body: Center(
        child: circle
        ? Loading()
        : SafeArea(
          child: Column(
            children: [
              ClipPath(
                clipper: RoundedClipper(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.22,
                  color: Color.fromARGB(255, 175, 174, 179),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "台灣即時更新數據(資料來源：疾管署)",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800]
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: InkWell(
                      child: Icon(Icons.refresh_outlined, color: Colors.grey[700], size: 28,),
                      onTap: () {
                        _getCovidInfo();
                      },
                    )
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 149, 148, 149),
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(2.0, 2.0), // shadow direction: bottom right
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 3, 5, 3),
                                child: Text('總確診人數', style: TextStyle(fontSize: 20.0),),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 3, 5, 3),
                                child: Text(
                                  _covidInfo.totalConfirmed, 
                                  style: TextStyle(fontSize: 25.0, color: Color.fromARGB(255, 246, 195, 100), fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                          InkWell(
                            child: Icon(Icons.keyboard_arrow_right_outlined, size: 35, color: Colors.grey[500],),
                            onTap: () {
          
                            },
                          )
                        ],
                      ),
                    ),                    
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.white,
                        boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 149, 148, 149),
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(2.0, 2.0), // shadow direction: bottom right
                            )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 3, 5, 3),
                                child: Text('本日確診', style: TextStyle(fontSize: 20.0),),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 3, 5, 3),
                                child: Text(
                                  _covidInfo.newTotalConfirmed, 
                                  style: TextStyle(fontSize: 25.0, color: Color.fromARGB(255, 246, 195, 100), fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                          InkWell(
                            child: Icon(Icons.keyboard_arrow_right_outlined, size: 35, color: Colors.grey[500],),
                            onTap: () {
          
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 149, 148, 149),
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(2.0, 2.0), // shadow direction: bottom right
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 3, 5, 3),
                                child: Text('境外', style: TextStyle(fontSize: 20.0),),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 3, 5, 3),
                                child: Text(
                                  (int.parse(_covidInfo.newTotalConfirmed) - int.parse(_covidInfo.newLocalConfirmed)).toString(), 
                                  style: TextStyle(fontSize: 25.0, color: Color.fromARGB(255, 246, 195, 100), fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                          InkWell(
                            child: Icon(Icons.keyboard_arrow_right_outlined, size: 35, color: Colors.grey[500],),
                            onTap: () {
          
                            },
                          )
                        ],
                      ),
                    ),                    
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 149, 148, 149),
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(2.0, 2.0), // shadow direction: bottom right
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 3, 5, 3),
                                child: Text('境內', style: TextStyle(fontSize: 20.0),),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 3, 5, 3),
                                child: Text(
                                  _covidInfo.newLocalConfirmed, 
                                  style: TextStyle(fontSize: 25.0, color: Color.fromARGB(255, 246, 195, 100), fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                          InkWell(
                            child: Icon(Icons.keyboard_arrow_right_outlined, size: 35, color: Colors.grey[500],),
                            onTap: () {
          
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "防疫警告",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800]
                ),
              ),
              SwitchButton(
                backgroundColor: Colors.white,
                buttonColor: Color.fromARGB(255, 246, 195, 100),
                values: ['off', 'on'], 
                onToggleCallback: (val) {
                  setState(() {
                    _toggleValue = val;
                  });
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}