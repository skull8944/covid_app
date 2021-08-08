import 'package:covid_app/screens/auth/login.dart';
import 'package:covid_app/screens/home/setting_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  
  Future<String?> getEmail() async {    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    return email;
  }

  Future<String?> getName() async {    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Drawer(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.grey[700]
                    ),
                    accountName: FutureBuilder(
                      future: getName(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  
                        return Text(snapshot.data.toString(), style: TextStyle(fontSize: 20.0, color: Colors.white),);
                      },                
                    ),
                    accountEmail: FutureBuilder(
                      future: getEmail(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  
                        return Text(snapshot.data.toString(), style: TextStyle(fontSize: 20.0, color: Colors.white),);
                      },                
                    ),
                    currentAccountPicture: CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage('https://stickershop.line-scdn.net/stickershop/v1/product/3349339/LINEStorePC/main.png;compress=true'),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person, size: 35.0,),
                    title: Text('Profile', style: TextStyle(fontSize: 18.0)),
                    onTap: () {                      
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsForm()));
                    },
                  ),
                  Divider(color: Colors.black,),
                ],
              )
            ),
            Container(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Divider(color: Colors.grey,),
                        ListTile(
                          leading: Icon(Icons.settings, size: 35.0),
                          title: Text('Settings', style: TextStyle(fontSize: 18.0)),
                          onTap: () {

                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.logout_outlined, size: 35.0),
                          title: Text('Logout', style: TextStyle(fontSize: 18.0)),
                          onTap: () async {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
                          },
                        ),
                      ],
                  )
                )
              )
            )
          ],
        ),
      )
    );
  }
}