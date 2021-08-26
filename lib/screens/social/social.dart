import 'package:covid_app/screens/home/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey[700]),
        elevation: 0,
      ),
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
          itemCount: 100,
          itemBuilder:(BuildContext context, int index) {
            return ListTile(
              title: Text('Item: $index'),
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
            
          },
        )
        : null,
    );
  }
}