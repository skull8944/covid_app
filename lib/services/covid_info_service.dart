import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:covid_app/models/covid_info.dart';

class CovidInfoService {  

  Future<CovidInfo> getCovidInfo() async {
    final res = await http.Client().get(Uri.parse('https://covid-19.nchc.org.tw/api/covid19?CK=covid-19@nchc.org.tw&querydata=4001&limited=TWN'));
    if(res.statusCode == 200) {
      var data = json.decode(res.body);
      CovidInfo covidInfo = CovidInfo(data[0]['a04'], data[0]['a05'], data[0]['a06'], data[0]['a08'], data[0]['a09']);
      return covidInfo;
    } else {
      throw Exception();
    }
  } 

}