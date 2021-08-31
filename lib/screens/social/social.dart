import 'package:covid_app/screens/home/menu_drawer.dart';
import 'package:covid_app/screens/social/add_post.dart';
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

  bool _showPlusButton = true;
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
      backgroundColor: Colors.white,
      drawer: MenuDrawer(),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          setState(() {
            if(notification.direction == ScrollDirection.forward) {
              _showPlusButton = true;
            } else if(notification.direction == ScrollDirection.reverse) {
              _showPlusButton = false;
            }
          });
          return true;
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: 5,
          itemBuilder:(BuildContext context, int index) {
            return BlogList(
              userName: index.toString(), 
              imgUrls: imgUrls
            );
          }
          ),
      ),      
      floatingActionButton: 
        _showPlusButton
        ? FloatingActionButton(
          backgroundColor: Colors.grey[700],
          child: Icon(Icons.add_rounded, size: 28.0,),
          onPressed: () {
            showModalBottomSheet(
              context: context, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )
              ), 
              enableDrag: true,
              isDismissible: false,
              isScrollControlled: true,
              builder: (context) => AddPost()
            );
          },
        )
        : null,
    );
  }
}