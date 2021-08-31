import 'package:covid_app/models/profile.dart';
import 'package:covid_app/models/user.dart';
import 'package:covid_app/screens/auth/login.dart';
import 'package:covid_app/screens/home/seach.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:covid_app/services/profile_service.dart';
import 'package:covid_app/screens/profile/user_profile.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {

  static String imgUrl = 'https://stickershop.line-scdn.net/stickershop/v1/product/3349339/LINEStorePC/main.png;compress=true';
  ProfileService _profileService = ProfileService();
  Profile _profile = Profile('', '', '', '', imgUrl);
  User _user = User('', '', '');
  int imgVersion = 0;
  bool circle = false;

  void _getProfile() async {
    _profile = await _profileService.getPro();
    if(mounted) {
      setState(() {
        if(_profile.imgUrl == '' || _profile.imgUrl.isEmpty) {
          _profile.imgUrl = imgUrl;
        } else {
          _profile.imgUrl += '?v=$imgVersion';
        }
        imgVersion++;
        circle = false;
      });
    }
    
    print('drawer: ${_profile.imgUrl}');
  }

  void _getUser() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _user.email = (_prefs.getString('email'))!;
      _user.token = (_prefs.getString('token'))!;
      _user.name = (_prefs.getString('name'))!;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return circle
    ? CircularProgressIndicator()
    : SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.56,
        child: Drawer(
          child: Ink(
            color: Colors.grey[600],
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Ink(
                        color: Colors.grey[500],
                        child: ListTile(
                          leading: CircleAvatar(backgroundImage: NetworkImage(_profile.imgUrl), backgroundColor: Colors.grey,),
                          title: Text(_user.name, style: TextStyle(fontSize: 18.0, color: Colors.grey[800])),
                          onTap: () {
                          
                          },
                        ),
                      ),
                      Divider(color: Colors.black, height: 0,),
                      Ink(
                        color: Colors.grey[500],
                        child: ListTile(
                          leading: Icon(Icons.person_outline_rounded, size: 35.0, color: Colors.grey[800],),
                          title: Text('Profile', style: TextStyle(fontSize: 18.0, color: Colors.grey[800])),
                          onTap: () {         
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile( notifyParent: () { _getProfile(); }, imgVersion: imgVersion,)));
                          },
                        ),
                      ),
                      Divider(color: Colors.black, height: 0,),
                      Ink(
                        color: Colors.grey[500],
                        child: ListTile(
                          leading: Icon(Icons.search, size: 35.0, color: Colors.grey[800],),
                          title: Text('Search', style: TextStyle(fontSize: 18.0, color: Colors.grey[800])),
                          onTap: () {         
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
                          },
                        ),
                      ),
                    ],
                  )
                ),
                Divider(color: Colors.grey, thickness: 1, height: 0,),
                Container(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      children: <Widget>[
                        Divider(color: Colors.black, height: 0,),
                        Ink(
                          color: Colors.grey[500],
                          child: ListTile(
                            leading: Icon(Icons.settings_outlined, size: 35.0),
                            title: Text('Settings', style: TextStyle(fontSize: 18.0,  color: Colors.grey[800])),
                            onTap: () {
                          
                            },
                          ),
                        ),
                        Divider(color: Colors.black, height: 0,),
                        Ink(
                          color: Colors.grey[500],
                          child: ListTile(
                            leading: Icon(Icons.logout_outlined, size: 35.0),
                            title: Text('Logout', style: TextStyle(fontSize: 18.0, color: Colors.grey[800])),
                            onTap: () async {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
                            },
                          ),
                        ),
                      ],
                    )
                  )
                )
              ],
            ),
          ),          
        ),
      ),
    );
  }
}