import 'package:covid_app/screens/social/friend_request_view.dart';
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
  bool circle = false;
  FriendService _friendService = FriendService();

  void getFreindRequsets() async {
    setState(() {
      circle = true;
    });
    list = await _friendService.getFriendRequests();
    if(list.length > 0) {
      print(list[0]['recipient']);
      setState(() {
        listLength = list.length;
      });
    }
    setState(() {
      circle = false;
    });
  }

  Future refreshRequest() async {
    setState(() {
      circle = true;
    });
    list = await _friendService.getFriendRequests();
    if(list.length > 0) {
      setState(() {
        listLength = list.length;
      });
    }
    setState(() {
      circle = false;
    });
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
            circle
            ? Center(child: CircularProgressIndicator(color: Colors.grey,),)
            : Expanded(
              child: RefreshIndicator(
                onRefresh: refreshRequest,
                child: listLength == 0
                ? Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '尚未朋友請求',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 28
                          ),
                        ),
                        InkWell(
                          child: Icon(Icons.replay_rounded, color: Colors.grey[800], size: 35,),
                          onTap: () {
                            getFreindRequsets();
                          },
                        )
                      ],
                    ),
                  )
                )
                : ListView.builder(
                  itemCount: listLength,
                  itemBuilder: (context, index) => FriendRequestView(
                    userName:list[index]['requester'],
                    deleteRequest: () {
                      list.removeAt(index);
                      setState(() {
                        listLength--;
                      });
                    },
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