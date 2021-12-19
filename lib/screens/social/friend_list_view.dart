import 'package:covid_app/screens/social/personal_page.dart';
import 'package:covid_app/services/friend_service.dart';
import 'package:covid_app/services/profile_service.dart';
import 'package:flutter/material.dart';

class FriendListView extends StatefulWidget {
  final String userName;
  final Function deleteFriend;
  const FriendListView({ Key? key, required this.userName, required this.deleteFriend}) : super(key: key);

  @override
  _FriendListViewState createState() => _FriendListViewState();
}

class _FriendListViewState extends State<FriendListView> {

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
                      backgroundImage: NetworkImage(imgUrl),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      widget.userName,
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
                          userName: widget.userName, 
                          imgUrl:imgUrl 
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
                                dynamic result = await _friendService.rejectRequest(widget.userName);
                                if(result == 'success') {
                                  widget.deleteFriend();
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
    );
  }
}