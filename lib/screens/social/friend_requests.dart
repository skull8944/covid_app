import 'package:covid_app/screens/social/personal_page.dart';
import 'package:covid_app/services/friend_service.dart';
import 'package:flutter/material.dart';

class FriendRequest extends StatefulWidget {
  const FriendRequest({ Key? key }) : super(key: key);

  @override
  _FriendRequestState createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {

  int listLength = 0;
  List list = [];
  FriendService _friendService = FriendService();

  void getFreindRequsets() async {
    list = await _friendService.getFriendRequests();
    if(list.length > 0) {
      print(list[0]['recipient']);
      setState(() {
        listLength = list.length;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFreindRequsets();
    setState(() {
      listLength = list.length;
    });
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
                      '<  朋友請求 ',
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
            listLength == 0
            ? Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: Text(
                  '還沒有朋友請求',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                ),
              )
            )
            : Expanded(
              child: ListView.builder(
                itemCount: listLength,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.1, 
                    10,
                    MediaQuery.of(context).size.width * 0.1,
                    20
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 125,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
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
                    child: Column(
                      children: <Widget> [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                          ),
                          title: Text(
                            list[index]['requester'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PersonalPage(userName: list[index], imgUrl: 'https://stickershop.line-scdn.net/stickershop/v1/product/3349339/LINEStorePC/main.png;compress=true')));
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    color: Color.fromARGB(255, 246, 195, 100),
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    height: 35,
                                    child: Center(
                                      child: Text(
                                        'ACCEPT',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15
                                        ),
                                      )
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  dynamic result = await _friendService.acceptRequest(list[index]['requester']);
                                  print(result);
                                  if(result == 'success') {
                                    list.removeAt(index);
                                    setState(() {
                                      listLength--;
                                    });
                                  }                     
                                },
                              ),
                              InkWell(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    color: Colors.grey[800],
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    height: 35,
                                    child: Center(
                                      child: Text(
                                        'DELETE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15
                                        ),
                                      )
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  dynamic result = await _friendService.rejectRequest(list[index]['requester']);
                                  print(result);
                                  if(result == 'success') {
                                    list.removeAt(index);
                                    setState(() {
                                      listLength--;
                                    });
                                  }                                  
                                },
                              )
                            ],
                          ),
                        )
                      ],
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