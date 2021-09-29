import 'package:covid_app/screens/home/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:covid_app/screens/social/blogList.dart';

class Social extends StatefulWidget {
  const Social({ Key? key }) : super(key: key);
  
  @override
  _SocialState createState() => _SocialState();
}

class _SocialState extends State<Social> {

  ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<String> imgUrls = [
    'blogPhotos/61485a3737762103d8d8348820219202221mountain-landscape-1024x883.jpg.jpg',
    'blogPhotos/61485a3737762103d8d8348820219202221vector-mountain-sunset-landscape-first-person-view.webp.jpg',
    'blogPhotos/6148991cea590948601a27a620219202222nature-scene-with-river-hills-forest-mountain-landscape-flat-cartoon-style-illustration_1150-37326.jpg.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      backgroundColor: Color.fromARGB(255, 236, 236, 239),      
      body:ListView.builder(
        itemCount: 5,
        itemBuilder:(BuildContext context, int index) {
          return BlogList(
            postID: '87',
            userName: 'YuZhi', 
            date: DateTime.now().year.toString() + '/' + DateTime.now().month.toString() + '/' + DateTime.now().day.toString(),
            imgUrls: imgUrls,
            time: '06:12',
            distance: '13m',
            deletePost: () {
             
            },
          );
        }          
      ),      
    );
  }
}