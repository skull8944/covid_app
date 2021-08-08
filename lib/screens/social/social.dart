import 'package:flutter/material.dart';

class Social extends StatelessWidget {
  const Social({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('SOCIAL'),),      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[700],
        child: Icon(Icons.post_add_rounded, size: 28.0,),
        onPressed: () {
          
        },
      ),
    );
  }
}