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
      });
     }
   }
   setState(() {
     circle = false;
   });
  }

  Future<void> refreshPost() async {
    List<Blog> friendPostList = await _blogService.getFriendPost();
    setState(() {
      circle = true;
    });
    if(friendPostList.length > 0) {
      setState(() {
        friendPost.clear();
        friendPost = friendPostList;
        postLength = friendPost.length;
      });
    }
    setState(() {
      circle = false;
    });
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
      ? Center(child: CircularProgressIndicator(color: Colors.grey,))
      : RefreshIndicator(
        onRefresh: refreshPost,
        child: postLength > 0
        ? ListView.builder(
          itemCount: postLength,
          itemBuilder:(BuildContext context, int i) {
            return BlogList(
              blog: friendPost[i],
              deletePost: () {
              
              },
            );
          }          
        )       
        : Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Column(
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
                    getPosts();
                  },
                )
              ],
            ),
          )
        )
      )      
    );
  }
}