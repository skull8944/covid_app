import 'package:covid_app/screens/home/setting_form.dart';
import 'package:flutter/material.dart';
import '../auth/login.dart';
import 'package:covid_app/screens/auth/login.dart';
import 'package:covid_app/screens/social/social.dart';
import 'package:covid_app/screens/running/runnig.dart';
import 'package:covid_app/screens/diet/diet.dart';
import 'package:covid_app/screens/covid/covid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:covid_app/screens/home/menu_drawer.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int screenIndex = 0;
  final screens = [Social(), Running(), Diet(), Covid()];

  void _changePage(int index) {
    if(screenIndex != index) {
      setState(() {
        screenIndex = index;
      });
    }
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey[700]),
      ),
      drawer: MenuDrawer(),
      body: IndexedStack(
        index: screenIndex,
        children: screens,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0)
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/img/home.svg', height: 30.0, width: 30.0, color: screenIndex == 0 ? Colors.grey[700] : Color.fromARGB(100, 159, 159, 160),),
              label: 'Home',
              backgroundColor: Color.fromARGB(255, 230, 230, 232)
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/img/running.svg', height: 30.0, width: 30.0, color: screenIndex == 1 ? Colors.grey[700] : Color.fromARGB(100, 159, 159, 160),),
              label: 'Running',
              backgroundColor: Color.fromARGB(255, 230, 230, 232)
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/img/diet.svg', height: 30.0, width: 30.0, color: screenIndex == 2 ? Colors.grey[700] : Color.fromARGB(100, 159, 159, 160),),
              label: 'Diet',
              backgroundColor: Color.fromARGB(255, 230, 230, 232)
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/img/covid.svg', height: 30.0, width: 30.0, color: screenIndex == 3 ? Colors.grey[700] : Color.fromARGB(100, 159, 159, 160),),
              label: 'Covid',
              backgroundColor: Color.fromARGB(255, 230, 230, 232)
            ),
          ],
          currentIndex: screenIndex,
          unselectedItemColor: Color.fromARGB(100, 159, 159, 160),
          selectedItemColor: Colors.grey[700],
          onTap: (index) {
            _changePage(index);
          }
        ),
      ),
    );
  }
}
