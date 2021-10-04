import 'package:covid_app/models/profile.dart';
import 'package:covid_app/screens/auth/login.dart';
import 'package:covid_app/screens/home/loading.dart';
import 'package:covid_app/screens/profile/setting_form.dart';
import 'package:covid_app/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/screens/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  bool _hasUser = false;
  bool circle = true;

  void checkUser() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? token = _prefs.getString('name');
    String? name = _prefs.getString('token');
    if(token!.isNotEmpty && token != '' && name!.isNotEmpty && name != '') {
      setState(() {
        _hasUser = true;
        setState(() {
          circle = false;
        });
      });
    } else {
      setState(() {
        circle = false;
      });
    }    
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: circle
        ? CircularProgressIndicator()
        : _hasUser
          ? Home()
          : Login(),
    );
  }
}