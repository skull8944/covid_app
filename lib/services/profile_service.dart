import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:covid_app/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileService {

  Future uploadProfile(String sex, String height, String weight, String birthdate) async {
    try {
      SharedPreferences prefs =  await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      print(token);
      final res = await http.post(Uri.parse('http://172.20.10.13:7414/user_profile/$token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(<String, String>{
          'sex': sex,
          'height': height,
          'weight': weight,
          'birthdate': birthdate
        }));

      if(res.statusCode == 200 || res.statusCode == 201) {
        print(jsonDecode(res.body));
        return (jsonDecode(res.body));
      } else {
        return ('error');
      }   
    } catch(err) {
      print(err);
    }
  }

  Future getProfile() async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final res = await http.Client().get(Uri.parse('http://172.20.10.13:7414/user_profile/$token'));
    if(res.statusCode == 200 || res.statusCode == 201) {
      print(jsonDecode(res.body));
    }    
  }

  Future patchImage(String filepath) async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var req = http.MultipartRequest('PATCH', Uri.parse('http://172.20.10.13:7414/user_profile/addimg/$token'));
    req.files.add(await http.MultipartFile.fromPath("img", filepath));
    req.headers.addAll({
      "Content-Type": "multipart/form-data",
    });
    var res = req.send();
    return res;
  }
  
}