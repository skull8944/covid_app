import 'dart:async';
import 'dart:io';
import 'package:covid_app/screens/profile/birthdate_edit.dart';
import 'package:covid_app/screens/profile/sex_edit.dart';
import 'package:covid_app/screens/profile/weight_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/services/profile_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:covid_app/screens/profile/height_edit.dart';
import 'package:covid_app/models/profile.dart';
import 'package:covid_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  final Function() notifyParent;
  const UserProfile({ Key? key, required this.notifyParent }) : super(key: key);


  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {  

  static String imgUrl = 'https://stickershop.line-scdn.net/stickershop/v1/product/3349339/LINEStorePC/main.png;compress=true';
  final _profileService = ProfileService();
  final _picker = ImagePicker();
  File? file;
  var filePath;
  bool circle = false;
  bool _showHeightEdit = false;
  bool _showWeightEdit = false;
  bool _showSexEdit = false;
  bool _showBirthdateEdit = false;
  Profile _profile = Profile('', '', '', '', '', imgUrl);
  User _user = User('', '', '');

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        filePath = pickedFile.path;
      } else {
        print('No image selected.');
      }
    });
  }

  void _getProfile() async {
    _profile = await _profileService.getPro();
    if(mounted) {
      setState(() {
        if(_profile.imgUrl == '' || _profile.imgUrl.isEmpty) {
          _profile.imgUrl = imgUrl;
        } 
        circle = false;
      });
    }    
    print('pro: ${_profile.imgUrl}');
  }

  void _getUser() async {    
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _user.email = _prefs.getString('email').toString();
    _user.token = _prefs.getString('token').toString();
    _user.name = _prefs.getString('name').toString();
    print('user: ${_user.email} ${_user.name}');
  }
  
  @override
  void initState() {
    super.initState();
    _getProfile();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        '<  個人資料  ',
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
              ? CircularProgressIndicator()
              : Column(
                children: [
                  SizedBox(height: 15.0,),
                  Container(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 56.0,
                          backgroundColor: Colors.grey[500],
                          backgroundImage: NetworkImage(_profile.imgUrl)
                        ),
                        Positioned(
                          left: 60.0,
                          top:  70.0,
                          child: ElevatedButton(
                            child: Icon(Icons.camera_alt),
                            onPressed: () {  
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => bottomSheet()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              primary: Colors.grey[800],
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Text(_user.name, style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500),),
                  Text(_user.email, style: TextStyle(fontSize: 18.0)),
                  SizedBox(height: 45.0,),
                  ListTile(
                    leading: Text('身高:', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${_profile.height} ', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                        Container(
                          width: 25.0,
                          child: TextButton(
                            child: _showHeightEdit ? Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 30.0,)
                              :Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white, size: 30.0,),
                            onPressed:() {
                              setState(() {
                                _showHeightEdit = !_showHeightEdit;
                              });
                            } 
                          ),
                        )
                    ],),
                    tileColor: Colors.grey[500],
                  ),
                  _showHeightEdit == false
                  ? SizedBox() 
                  : HeightEdit( notifyParent: () { _getProfile(); },),
                  ListTile(
                    leading: Text('體重:', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${_profile.weight} ', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                        Container(
                          width: 25.0,
                          child: TextButton(
                            child: _showWeightEdit ? Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 30.0,)
                              :Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white, size: 30.0,),
                            onPressed:() {
                              setState(() {
                                _showWeightEdit = !_showWeightEdit;
                              });
                            } 
                          ),
                        )
                    ],),
                    tileColor: Colors.grey[500],
                  ),
                  _showWeightEdit == false
                  ? SizedBox() 
                  : WeightEdit( notifyParent: () { _getProfile(); },),
                  ListTile(
                    leading: Text('性別:', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${_profile.sex} ', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                        Container(
                          width: 25.0,
                          child: TextButton(
                            child: _showSexEdit ? Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 30.0,)
                              :Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white, size: 30.0,),
                            onPressed:() {
                              setState(() {
                                _showSexEdit = !_showSexEdit;
                              });
                            } 
                          ),
                        )
                    ],),
                    tileColor: Colors.grey[500],
                  ),
                  _showSexEdit == false
                  ? SizedBox() 
                  : SexEdit( notifyParent: () { _getProfile(); },),
                  ListTile(
                    leading: Text('生日:', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${_profile.birthdate} ', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                        Container(
                          width: 25.0,
                          child: TextButton(
                            child: _showBirthdateEdit ? Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 30.0,)
                              :Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white, size: 30.0,),
                            onPressed:() {
                              setState(() {
                                _showBirthdateEdit = !_showBirthdateEdit;
                              });
                            } 
                          ),
                        )
                    ],),
                    tileColor: Colors.grey[500],
                  ),
                  _showBirthdateEdit == false
                  ? SizedBox() 
                  : BirthdateEdit( notifyParent: () { _getProfile(); }, ),
                ],
              )
            ]
          ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "請選擇照片來源",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera, color: Colors.grey[700],),
              onPressed: () async {
                setState(() {
                  circle = true;
                });
                await getImage(ImageSource.camera);
                await _profileService.patchImage(filePath);
                await Future.delayed(Duration(seconds: 1));
                _getProfile();    
                widget.notifyParent();       
              },
              label: Text("相機", style: TextStyle(color: Colors.grey[700], fontSize: 20.0),),
            ),
            TextButton.icon(
              icon: Icon(Icons.image, color: Colors.grey[700],),
              onPressed: () async {
                setState(() {
                  circle = true;
                });
                await getImage(ImageSource.gallery);
                await _profileService.patchImage(filePath);
                await Future.delayed(Duration(seconds: 1));
                _getProfile();
                widget.notifyParent();
              },
              label: Text("相簿", style: TextStyle(color: Colors.grey[700], fontSize: 20.0),),
            ),
          ])
        ],
      ),
    );
  }
}