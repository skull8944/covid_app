import 'package:covid_app/models/blog.dart';
import 'package:covid_app/services/blog_service.dart';
import 'package:covid_app/services/friend_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'blogList.dart';

class PersonalPage extends StatefulWidget {
  final String userName;
  final String imgUrl;
  PersonalPage({ Key? key, required this.userName, required this.imgUrl}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {

  FriendService _friendService = FriendService();
  BlogService _blogService = BlogService();
  List<Blog> myBlogList = [];
  bool circle = true;
  bool statusCircle = true;
  int postLength = 0;
  int friendStatus = 0;
  List friendStatusList = ['加好友', '申請中', {'確認', '取消'}, '好友'];

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

  Future<void> refreshPost() async {
    List<Blog> friendPostList = await _blogService.getPost(widget.userName);
    
    if(friendPostList.length > 0) {
      setState(() {
        myBlogList.clear();
        myBlogList = friendPostList;
        postLength = myBlogList.length;
      });
    }
  }

  void getFriendStatus() async {
   setState(() {
     statusCircle = true;
   });
   int fstatus = await _friendService.getFriendStatus(widget.userName);
   print(fstatus);
   setState(() {
     friendStatus = fstatus;
     statusCircle = false;
   });
  }

  @override
  void initState() {    
    super.initState();
    getFriendStatus();
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
              statusCircle
              ? CircularProgressIndicator()               
              : friendStatus == 2
                ? Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Container(
                        width: 65,
                        color: Color.fromARGB(255, 246, 195, 100),
                        padding: EdgeInsets.all(5),
                        child: InkWell(
                          child: Center(child: Text('接受')),
                          onTap: () async {
                            setState(() {
                              statusCircle = true;
                            });
                            dynamic result = await _friendService.acceptRequest(widget.userName);
                            if(result == 'success') {
                              setState(() {
                                friendStatus = 3;
                                statusCircle = false;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Container(
                        width: 65,
                        color: Color.fromARGB(255, 149, 148, 149),
                        padding: EdgeInsets.all(5),
                        child: InkWell(
                          child: Center(child: Text('拒絕')),
                          onTap: () async {
                            setState(() {
                              statusCircle = true;
                            });
                            dynamic result = await _friendService.rejectRequest(widget.userName);
                            if(result == 'success') {
                              setState(() {
                                friendStatus = 0;
                                statusCircle = false;
                              });
                            }
                          },
                        ),
                      ),
                    )
                  ],
                )
                : InkWell(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Container(
                      color: Colors.grey,
                      width: 80,
                      height: 35,
                      child: Center(
                        child: Text(
                          friendStatusList[friendStatus],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ),
                    )
                  ),
                  onTap: () async {
                    switch (friendStatus) {
                      case 0:
                        print('add');
                        setState(() {
                          statusCircle = true;
                        });
                        dynamic result = await _friendService.addFriend(widget.userName);
                        print(result);
                        if(result == 'success') {
                          setState(() {
                            friendStatus = 1;
                            statusCircle = false;
                          });
                          print('status： '+friendStatus.toString());
                        }
                        break;
                      case 1:
                        print('reject');
                        setState(() {
                          statusCircle = true;
                        });
                        dynamic result = await _friendService.rejectRequest(widget.userName);
                        print(result);
                        if(result == 'success') {
                          setState(() {
                            friendStatus = 0;
                            statusCircle = false;
                          });
                          print('status： '+friendStatus.toString());
                        }
                        break;
                      case 3:
                        showDialog(
                          context: context, 
                          builder: (BuildContext context) => AlertDialog(
                            content: Text(
                              '確定取消好友關係?', 
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20
                              ),),
                            actions: <Widget> [
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Text(
                                    '確定',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.green
                                    ),
                                  )
                                ),
                                onTap: () async {
                                  dynamic result = await _friendService.rejectRequest(widget.userName);
                                  if(result == 'success') {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Text(
                                    '取消',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.red
                                    ),
                                  )
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              )
                            ]
                          )                                    
                        );
                        break; 
                      default:
                        print('default');
                        break;
                    }                  
                  },
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
                child: RefreshIndicator(
                  onRefresh: refreshPost,
                  child: myBlogList.length == 0
                  ? Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Text(
                        '還沒有貼文',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20
                        ),
                      )
                    )
                  )
                  : ListView.builder(
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
            ],
          ),
        ),
      ),
    );
  }
}