import 'package:covid_app/models/blog.dart';
import 'package:covid_app/services/blog_service.dart';
import 'package:flutter/material.dart';

import 'blogList.dart';

class MyPost extends StatefulWidget {
  const MyPost({ Key? key }) : super(key: key);

  @override
  _MyPostState createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {

  BlogService _blogService = BlogService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromARGB(255, 236, 236, 239),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey[850]),
      ),
      body: FutureBuilder(
        future: _blogService.getMyPost(),
        builder: (BuildContext context, AsyncSnapshot<List<Blog>> snapshot) {
          return Center(
            child: snapshot.connectionState != ConnectionState.done          
            ? CircularProgressIndicator()
            : snapshot.data!.length < 1
              ? null
              : ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int i) {
                  return BlogList(
                    userName: snapshot.data![i].userName, 
                    date: snapshot.data![i].updatedTime,
                    imgUrls: snapshot.data![i].images,
                    time: snapshot.data![i].time,
                    distance: snapshot.data![i].distance,
                  );
                }
              )
          );
        },
      )
    );
  }
}