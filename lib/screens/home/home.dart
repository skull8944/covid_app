import 'package:covid_app/models/profile.dart';
import 'package:covid_app/screens/home/menu_drawer.dart';
import 'package:covid_app/screens/profile/setting_form.dart';
import 'package:covid_app/screens/social/mypost.dart';
import 'package:covid_app/screens/social/personal_page.dart';
import 'package:covid_app/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/screens/social/social.dart';
import 'package:covid_app/screens/running/runnig.dart';
import 'package:covid_app/screens/diet/diet.dart';
import 'package:covid_app/screens/covid/covid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String myName = '';
  bool _search = false;
  int screenIndex = 0;
  final screens = [Social(), Running(), Diet(), Covid()];
  bool circle = false;
  bool _hasProfile = true;
  ProfileService _profileService = ProfileService();

  void _changePage(int index) {
    if(screenIndex != index) {
      setState(() {
        screenIndex = index;
      });
    }
  }  

  void checkProfile() async {
    final res = await _profileService.getProfile();
    if(res == 'no data') {
      setState(() {
        circle = false;
        _hasProfile = false;
      });
    } else {
      setState(() {
        circle = false;
      });
    }
  }

  void getMyName() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? name = _prefs.getString('name');
    setState(() {
      myName = name!;
    });
    print(myName);
  }

  @override
  void initState() {
    super.initState();
    getMyName();
    checkProfile();
  }

  @override
  Widget build(BuildContext context) {
    return circle
    ? CircularProgressIndicator()
    : _hasProfile 
      ? Scaffold(
        appBar: screenIndex == 0
        ? AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.grey[700]),
            elevation: 0,
            actions: <Widget>[
              _search 
                ? Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TypeAheadField<Profile>(
                    hideSuggestionsOnKeyboardHide: false,
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: '搜尋使用者'
                      )
                    ),
                    suggestionsCallback: _profileService.getUserSuggestions,
                    onSuggestionSelected: (Profile suggestions) {
                      final user = suggestions;
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => 
                        user.name == myName
                        ? MyPost()
                        : PersonalPage(userName: user.name, imgUrl: user.imgUrl,))
                      );
                    },
                    itemBuilder: (context, Profile suggestions) {
                      final user = suggestions;
                      return Container(
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            child: Image.network(user.imgUrl)
                          ),
                          title: Text(user.name),
                        ),
                      );
                    },
                    noItemsFoundBuilder: (context) => Container(
                      height: 100,
                      child: Center(
                        child: Text('找不到使用者', style: TextStyle(fontSize: 20),),
                      ),
                    ),
                  )
                )
              : Container(width: MediaQuery.of(context).size.width * 0.8,),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: _search ? Icon(Icons.close, size: 28,)
                                  : Icon(Icons.search_rounded, size: 28,)
                  ),
                  onTap: () {
                    setState(() {
                      _search = !_search;
                    });
                  },
                ),
              ),
            ],
          )
        : null,
        extendBody: true,
        drawer: screenIndex == 0
          ? MenuDrawer()
          : null,
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
      )
    : SettingsForm();
  }
}
