import 'package:flutter/material.dart';
import 'package:covid_app/screens/social/social.dart';
import 'package:covid_app/screens/running/runnig.dart';
import 'package:covid_app/screens/diet/diet.dart';
import 'package:covid_app/screens/covid/covid.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      extendBody: true,
      body: IndexedStack(
        index: screenIndex,
        children: screens,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(14.0),
        child: SafeArea(
          child: Container(            
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 149, 148, 149),
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0)
                )
              ]
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: screenIndex == 0
                      ? Image.asset('assets/img/home.png', height: 30.0, width: 30.0)
                      : SvgPicture.asset('assets/img/home.svg', height: 30.0, width: 30.0, color: Colors.black,),
                    label: 'Home',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: screenIndex == 1
                      ? Image.asset('assets/img/running.png', height: 30.0, width: 30.0)
                      : SvgPicture.asset('assets/img/running.svg', height: 30.0, width: 30.0, color: Colors.black,),                    
                    label: 'Running',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: screenIndex == 2
                      ? Image.asset('assets/img/diet.png', height: 30.0, width: 30.0)
                      : SvgPicture.asset('assets/img/diet.svg', height: 30.0, width: 30.0, color: Colors.black,),                    
                    label: 'Diet',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(                    
                    icon: screenIndex == 3
                      ? Image.asset('assets/img/covid.png', height: 30.0, width: 30.0)
                      : SvgPicture.asset('assets/img/covid.svg', height: 30.0, width: 30.0, color: Colors.black,),
                    label: 'Covid',
                    backgroundColor: Colors.white,
                  ),
                ],
                elevation: 14,
                enableFeedback: false,
                showSelectedLabels: false,
                backgroundColor: Colors.red,
                currentIndex: screenIndex,
                selectedItemColor: Colors.grey[700],
                onTap: (index) {
                  _changePage(index);
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}
