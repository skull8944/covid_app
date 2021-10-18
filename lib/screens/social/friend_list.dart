import 'package:covid_app/screens/social/personal_page.dart';
import 'package:covid_app/services/friend_service.dart';
import 'package:flutter/material.dart';

class FriendList extends StatefulWidget {
  const FriendList({ Key? key }) : super(key: key);

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {

  FriendService _friendService = FriendService();
  List friends = [];
  int friendsLength = 0;

  void getFriends() async {
    List friendList = await _friendService.getFriends();
    if(friendList.length > 0) {
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
                      '<  Friends  ',
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
                  'No Friends',
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
                                  backgroundColor: Colors.black,
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
                                  onTap: () async {
                                    dynamic result = await _friendService.rejectRequest(friends[index]['requester']);
                                    if(result == 'success') {
                                      friends.removeAt(index);
                                      setState(() {
                                        friendsLength--;
                                      });
                                    }
                                  },
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