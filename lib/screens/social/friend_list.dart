import 'package:covid_app/models/profile.dart';
import 'package:covid_app/screens/social/friend_list_view.dart';
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
  bool circle = false;

  void getFriends() async {
    setState(() {
      circle = true;
    });
    List friendList = await _friendService.getFriends();
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
    setState(() {
      circle = false;
    });
  }

  Future refreshFriends() async {
    setState(() {
      circle = true;
    });
    List friendList = await _friendService.getFriends();
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
    setState(() {
      circle = false;
    });
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
            circle
            ? Center(child: CircularProgressIndicator(color: Colors.grey,))
            : Expanded(
              child: RefreshIndicator(
                onRefresh: refreshFriends,
                child: friendsLength == 0
                ? Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Column(
                    children: [
                      Text(
                        '尚未有朋友',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 28
                        ),
                      ),
                      InkWell(
                        child: Icon(Icons.replay_rounded, color: Colors.grey[800], size: 35,),
                        onTap: () {
                          getFriends();
                        },
                      )
                    ],
                  ),
                  )
                )
                : ListView.builder(
                  itemCount: friendsLength,
                  itemBuilder: (context, index) => FriendListView(
                    userName: friends[index]['requester'], 
                    deleteFriend: () {
                      friends.removeAt(index);
                      setState(() {
                        friendsLength--;
                      });
                    }
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}