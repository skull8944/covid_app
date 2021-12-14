import 'package:covid_app/models/profile.dart';
import 'package:covid_app/screens/social/personal_page.dart';
import 'package:covid_app/services/friend_service.dart';
import 'package:covid_app/services/profile_service.dart';
import 'package:flutter/material.dart';

class FriendList extends StatefulWidget {
  const FriendList({ Key? key }) : super(key: key);

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {

  FriendService _friendService = FriendService();
  ProfileService _profileService = ProfileService();
  List friends = [];
  int friendsLength = 0;
  List imgUrls = [];
  String imgUrl = 'https://stickershop.line-scdn.net/stickershop/v1/product/3349339/LINEStorePC/main.png;compress=true';

  void getFriends() async {
    List friendList = await _friendService.getFriends();
    print(friendList);
    if(friendList.length > 0) {
      for(var i = 0; i < friendList.length; i++) {
        Profile result = await _profileService.getFriendPro(friendList[i]['requester']);
        if(result.imgUrl != null && result.imgUrl != '' ) {
          imgUrls.add(result.imgUrl);
        }
      }
      setState(() {
        friends = friendList;
        friendsLength = friendList.length;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFriends();
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
                      '<  朋友  ',
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
            friendsLength == 0
            ? Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: Text(
                  '還沒有朋友',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                ),
              )
            )
            : Expanded(
              child: ListView.builder(
                itemCount: friendsLength,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.1, 
                    10,
                    MediaQuery.of(context).size.width * 0.1,
                    20
                  ),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 149, 148, 149),
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 2.0)
                        )
                      ]
                    ),
                    child: Row(
                      children: <Widget>[ 
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(3.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(imgUrls[index]),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  friends[index]['requester'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),                        
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(3.0),
                                child: InkWell(
                                  child: Icon(
                                    Icons.info_outline_rounded, color: Color.fromARGB(255, 246, 195, 100), size: 28,
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalPage(
                                      userName: friends[index]['requester'], 
                                      imgUrl:friends[index]['requester'] 
                                    )));
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(3.0),
                                child: InkWell(
                                  child: Icon(
                                    Icons.delete_rounded, color: Colors.grey[700], size: 28,
                                  ),
                                  onTap: () => showDialog(
                                    context: context, 
                                    builder: (BuildContext context) => AlertDialog(
                                      content: Text(
                                        '確定刪除好友?', 
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
                                            dynamic result = await _friendService.rejectRequest(friends[index]['requester']);
                                            if(result == 'success') {
                                              friends.removeAt(index);
                                              setState(() {
                                                friendsLength--;
                                              });
                                            }                                    
                                            Navigator.pop(context);
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
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    )
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}