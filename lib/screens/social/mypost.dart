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
  List<Blog> myBlogList = [];
  bool circle = false;
  int postLength = 0;

  @override
  void initState() {    
    super.initState();
    getPostList();
  }

  void getPostList() async {
    setState(() {
      circle = true;
    });
    List<Blog> blogList = await _blogService.getMyPost();
    if(blogList.length > 0) {
      setState(() {
        postLength = blogList.length;
        myBlogList = blogList;
      });
    }
    setState(() {
      circle = false;
    });
  }

  Future<void> refreshPost() async {
    setState(() {
      circle = true;
    });
    List<Blog> friendPostList = await _blogService.getMyPost();
    
    if(friendPostList.length > 0) {
      setState(() {
        myBlogList.clear();
        myBlogList = friendPostList;
        postLength = myBlogList.length;
      });
    }
    setState(() {
      circle = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 236, 239),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey[850]),
      ),
      body: Center(
        child: circle          
        ? CircularProgressIndicator()
        :  myBlogList.length == 0
          ? Column(
            children: [
              Text(
                '尚未有貼文',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 28
                ),
              ),
              InkWell(
                child: Icon(Icons.replay_rounded, color: Colors.grey[800], size: 35,),
                onTap: () {
                  getPostList();
                },
              )
            ],
          )
          : RefreshIndicator(
          onRefresh: refreshPost,
          child: ListView.builder(
            itemCount: postLength,
            itemBuilder: (BuildContext context, int i) {
              return BlogList(
                blog: myBlogList[i],
                deletePost: (String postID) {
                  myBlogList.removeWhere((item) => item.postID == postID);
                  setState(() {
                    postLength--;
                  });
                },
              );
            }          
                ),
          ),
  )
    );
  }
}