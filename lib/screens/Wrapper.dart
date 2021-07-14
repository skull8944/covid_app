import 'package:covid_app/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatelessWidget {  

  Future checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? name = prefs.getString('name');
    if((token != null && token != '') && (name != null && name != '')){
      print(token + name);
      return 'User(token, name)';
    } 
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData ? Home() : Login();
      }
    );
  }
}