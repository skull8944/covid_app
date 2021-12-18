import 'package:covid_app/screens/social/personal_page.dart';
import 'package:covid_app/services/friend_service.dart';
import 'package:covid_app/services/profile_service.dart';
import 'package:flutter/material.dart';

class FriendRequestView extends StatefulWidget {
  final String userName;
  final Function deleteRequest;
  const FriendRequestView({ Key? key, required this.userName, required this.deleteRequest }) : super(key: key);

  @override
  _FriendRequestViewState createState() => _FriendRequestViewState();
}

class _FriendRequestViewState extends State<FriendRequestView> {

  FriendService _friendService = FriendService();
  String imgUrl = '';
  ProfileService _profileService = ProfileService();

  void getImgUrl() async {
    final res = await _profileService.getFriendPro(widget.userName);
    print('imgUrl: '+res.imgUrl);
    if(res.imgUrl != '') {
      setState(() {
        imgUrl = res.imgUrl;
      });
    }
  } 

  @override
  void initState() {
    super.initState();
    getImgUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(imgUrl),
              ),
              title: Text(
                widget.userName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => PersonalPage(
                    userName:widget.userName, 
                    imgUrl: imgUrl
                  )
                ));
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
                            '接受',
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
                      dynamic result = await _friendService.acceptRequest(widget.userName);
                      print(result);
                      if(result == 'success') {
                        widget.deleteRequest();
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
                            '拒絕',
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
                      dynamic result = await _friendService.rejectRequest(widget.userName);
                      print(result);
                      if(result == 'success') {
                        widget.deleteRequest();
                      }                                  
                    },
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}