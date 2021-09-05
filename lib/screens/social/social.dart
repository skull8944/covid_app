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
    'https://stickershop.line-scdn.net/stickershop/v1/product/3349339/LINEStorePC/main.png;compress=true',
    'https://stickershop.line-scdn.net/stickershop/v1/product/3349339/LINEStorePC/main.png;compress=true',
    'https://stickershop.line-scdn.net/stickershop/v1/product/3349339/LINEStorePC/main.png;compress=true'
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey[700]),
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(255, 236, 236, 239),
      drawer: MenuDrawer(),
      body:ListView.builder(
        itemCount: 5,
        itemBuilder:(BuildContext context, int index) {
          return BlogList(
            userName: index.toString(), 
            imgUrls: imgUrls
          );
        }          
      ),      
    );
  }
}