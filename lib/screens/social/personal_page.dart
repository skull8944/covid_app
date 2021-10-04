import 'package:covid_app/models/blog.dart';
import 'package:covid_app/services/blog_service.dart';
import 'package:flutter/material.dart';

import 'blogList.dart';

class PersonalPage extends StatefulWidget {
  final String userName;
  final String imgUrl;
  PersonalPage({ Key? key, required this.userName, required this.imgUrl}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {

  BlogService _blogService = BlogService();
  List<Blog> myBlogList = [];
  bool circle = false;
  int postLength = 0;

  void getPostList() async {
    setState(() {
      circle = true;
    });
    List<Blog> blogList = await _blogService.getPost(widget.userName);
    if(blogList.length > 0) {
      setState(() {
        myBlogList = blogList;
        postLength = blogList.length;
      });
    }
    setState(() {
      circle = false;
    });
  }

  @override
  void initState() {    
    super.initState();
    getPostList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: <Widget>[
            Expanded(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(widget.imgUrl,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.userName, 
                        style: TextStyle(color: Colors.grey[800], fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )
              ),                    
              InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Container(
                    color: Colors.grey,
                    width: 80,
                    height: 35,
                    child: Center(
                      child: Text(
                        'add freind',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                        ),
                      )
                    ),
                  )
                ),
              )
          ],
        ),
        /*Text(
          "${widget.userName}'s page", 
          style: TextStyle(color: Colors.grey[800]),
        ),*/
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[700]
        ),
      ),
      backgroundColor: Color.fromARGB(255, 236, 236, 239),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
             
              Expanded(
                child: myBlogList.length == 0
                  ? Text('No Post Yet')
                  : ListView.builder(
                  itemCount: postLength,
                  itemBuilder: (BuildContext context, int i) {
                    return BlogList(
                      postID: myBlogList[i].postID,
                      userName: myBlogList[i].userName, 
                      date: myBlogList[i].updatedTime,
                      imgUrls: myBlogList[i].images,
                      time: myBlogList[i].time,
                      distance: myBlogList[i].distance,
                      deletePost: (String postID) {
                        myBlogList.removeWhere((item) => item.postID == postID);
                        setState(() {
                          postLength--;
                        });
                      },
                    );
                  }          
                ),
              )                
            ],
          ),
        ),
      ),
    );
  }
}