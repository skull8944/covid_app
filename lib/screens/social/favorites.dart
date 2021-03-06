import 'package:covid_app/models/blog.dart';
import 'package:covid_app/screens/social/blogList.dart';
import 'package:covid_app/services/blog_service.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  const Favorites({ Key? key }) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

  BlogService _blogService = BlogService();
  List<Blog> favoriteBlog = [];
  int postLength = 0;
  bool circle = true;
  
  void getFavoritePost() async {
    setState(() {
      circle = true;
    });
    List<Blog> favoriteBlogList = await _blogService.getFavoritePost();
    if(favoriteBlogList.length > 0) {
      setState(() {
        favoriteBlog = favoriteBlogList;
        postLength = favoriteBlog.length;        
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
    List<Blog> friendPostList = await _blogService.getFavoritePost();    
    if(friendPostList.length > 0) {
      setState(() {
        favoriteBlog.clear();
        favoriteBlog = friendPostList;
        postLength = favoriteBlog.length;
      });
    }
    setState(() {
      circle = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getFavoritePost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 236, 239),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 0,
                top: MediaQuery.of(context).size.height * 0.04,
                bottom: MediaQuery.of(context).size.height * 0.02
              ),
              child: InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(35),
                    bottomRight: Radius.circular(35)
                  ),
                  child: Container(
                    padding: EdgeInsets.all(14),
                    color: Colors.grey[800],
                    child: Text(
                      '<  ??????  ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            circle
            ? Center(child: CircularProgressIndicator(color: Colors.grey,))
            : Expanded(
              child: RefreshIndicator(
              onRefresh: refreshPost,
              child: postLength > 0
              ? ListView.builder(
                itemCount: postLength,
                itemBuilder: (context, i) => BlogList(
                  blog: favoriteBlog[i],
                  deletePost: () {
            
                  }
                )
              )
              : Center(
                child: Column(
                  children: [
                    Text(
                      '???????????????',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 28
                      ),
                    ),
                    InkWell(
                      child: Icon(Icons.replay_rounded, color: Colors.grey[800], size: 35,),
                      onTap: () {
                        getFavoritePost();
                      },
                    )
                  ],
                ),
              ),
              )
            ),
          ]
        )
      )
    );
  }
}    