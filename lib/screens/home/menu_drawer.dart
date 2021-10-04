import 'package:covid_app/models/profile.dart';
import 'package:covid_app/models/user.dart';
import 'package:covid_app/screens/auth/login.dart';
import 'package:covid_app/screens/social/mypost.dart';
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
  Profile _profile = Profile('', '', '', '', '', imgUrl);
  User _user = User('', '', '');
  bool circle = false;

  void _getProfile() async {
    _profile = await _profileService.getPro();
    if(mounted) {
      setState(() {
        if(_profile.imgUrl == '' || _profile.imgUrl.isEmpty) {
          _profile.imgUrl = imgUrl;
        } 
        circle = false;
      });
    }
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
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40)
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.56,
          child: Drawer(
            child: Ink(
              color: Colors.grey[900],
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.04,
                            bottom: MediaQuery.of(context).size.height * 0.01 
                          ),
                          child: Ink(
                            color: Colors.grey[900],
                            child: ListTile(
                              leading: CircleAvatar(backgroundImage: NetworkImage(_profile.imgUrl), backgroundColor: Colors.grey,),
                              title: Text(_user.name, style: TextStyle(fontSize: 23.0, color: Colors.white)),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyPost()));
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.04,
                            right: MediaQuery.of(context).size.width * 0.05
                          ),
                          child: Divider(color: Colors.grey[700], thickness: 2,),
                        ),
                        Ink(
                          color: Colors.grey[900],
                          child: ListTile(
                            leading: Icon(Icons.person_outline_rounded, size: 35.0, color: Colors.white,),
                            title: Text('Profile', style: TextStyle(fontSize: 18.0, color: Colors.white)),
                            onTap: () {         
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile( notifyParent: () { _getProfile(); },)));
                            },
                          ),
                        ),
                        Ink(
                          color: Colors.grey[900],
                          child: ListTile(
                            leading: Icon(Icons.people_alt_outlined, size: 35.0, color: Colors.white,),
                            title: Text('Friends', style: TextStyle(fontSize: 18.0, color: Colors.white)),
                            onTap: () {         
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
                            },
                          ),
                        ),
                        Ink(
                          color: Colors.grey[900],
                          child: ListTile(
                            leading: Icon(Icons.group_add_rounded, size: 35.0, color: Colors.white,),
                            title: Text('Friend Requests', style: TextStyle(fontSize: 18.0, color: Colors.white)),
                            onTap: () {         
                              
                            },
                          ),
                        ),
                        Ink(
                          color: Colors.grey[900],
                          child: ListTile(
                            leading: Icon(Icons.turned_in_not_outlined, size: 35.0, color: Colors.white,),
                            title: Text('Favorites', style: TextStyle(fontSize: 18.0, color: Colors.white)),
                            onTap: () {         
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                  Divider(color: Colors.grey[700], thickness: 1, height: 0,),
                  Container(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Ink(
                        color: Colors.grey[900],
                        child:  Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.03,
                            bottom: MediaQuery.of(context).size.height * 0.03
                          ),
                          child: InkWell(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.height * 0.08,
                                color: Colors.grey[800],
                                child: Center(
                                  child: Text(
                                    'LOG OUT', 
                                    style: TextStyle(
                                      fontSize: 23.0, 
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600
                                    )
                                  ) 
                                )
                              )
                            ),
                            onTap: () async {
                              SharedPreferences _prefs = await SharedPreferences.getInstance();
                              await _prefs.clear();
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
                            },
                          ),
                        ),
                        
                      ),
                    )                    
                  )
                ],
              ),
            ),          
          ),
        ),
      ),
    );
  }
}