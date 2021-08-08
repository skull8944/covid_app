import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:covid_app/models/covid_info.dart';

class CovidInfoService {  

  Future<CovidInfo> getCovidInfo() async {
    final res = await http.Client().get(Uri.parse('http://172.20.10.13:7414/covid'));
    if(res.statusCode == 200) {
      var data = json.decode(res.body);
      CovidInfo covidInfo = CovidInfo(data['date'],
                                      data['totalConfirmed'], data['localConfirmed'], 
                                      data['newTotalConfirmed'], data['newLocalConfirmed'], 
                                      data['totalDeath'], data['newDeath'], 
                                      data['injection'], data['newInjection']);
      return covidInfo;
    } else {
      throw Exception();
    }
  } 

}