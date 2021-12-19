import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth{
  final String host = 'http://120.114.170.16:7414';
  Future signup(String email, String password, String name) async{
    var res = await http.post(Uri.parse("$host/signup"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8'
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'name': name
      }));

    if(res.statusCode == 201) {
      return json.decode(res.body);
    } else if(res.statusCode == 404) {
      Map<String, dynamic> map = new Map<String, dynamic>.from(json.decode(res.body))['errors'];
      return map;
    }
  }
  
  Future login(String email, String password) async{
    var res = await http.post(Uri.parse("$host/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8'
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password
      })); 

    if(res.statusCode == 200) {
      var response = json.decode(res.body);
      print(response);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', response['user']);
      prefs.setString('name', response['name']);
      prefs.setString('email', response['email']);

      return response;
    } else if(res.statusCode == 404) {
      Map<String, dynamic> map = new Map<String, dynamic>.from(json.decode(res.body))['errors'];
      return map;
    }
  }

}