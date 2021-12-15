import 'package:covid_app/models/blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:covid_app/screens/social/blogList.dart';
import 'package:covid_app/services/blog_service.dart';

class Social extends StatefulWidget {
  const Social({ Key? key }) : super(key: key);
  
  @override
  _SocialState createState() => _SocialState();
}

class _SocialState extends State<Social> {

  BlogService _blogService = BlogService();
  List<Blog> friendPost = [];
  bool circle = true;
  int postLength = 0;
  
  void getPosts() async {
    setState(() {
      circle = true;
    });

   List<Blog> friendPostList = await _blogService.getFriendPost();
   
   if(friendPostList.length > 0) {
     if(mounted) {
       setState(() {
        friendPost = friendPostList;
        postLength = friendPost.length;
        circle = false;
      });
     }
   }
  }

  Future<void> refreshPost() async {
    List<Blog> friendPostList = await _blogService.getFriendPost();
    
    if(friendPostList.length > 0) {
      setState(() {
        friendPost.clear();
        friendPost = friendPostList;
        postLength = friendPost.length;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(     
      backgroundColor: Color.fromARGB(255, 236, 236, 239),      
      body: circle
      ? Center(child: CircularProgressIndicator())
      : postLength > 0
        ? RefreshIndicator(
          onRefresh: refreshPost,
          child: ListView.builder(
            itemCount: postLength,
            itemBuilder:(BuildContext context, int i) {
              return BlogList(
                postID: friendPost[i].postID,
                userName: friendPost[i].userName, 
                date: friendPost[i].updatedTime,
                imgUrls: friendPost[i].images,
                time: friendPost[i].time,
                distance: friendPost[i].distance,
                collect: friendPost[i].collect,
                deletePost: () {
                
                },
              );
            }          
          ),
        )
        : Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
              child: Text(
                '還沒有貼文',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
        )      
    );
  }
}