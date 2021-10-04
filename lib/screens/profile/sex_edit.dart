import 'package:covid_app/models/profile.dart';
import 'package:covid_app/services/profile_service.dart';
import 'package:flutter/material.dart';

class SexEdit extends StatefulWidget {
  final Function() notifyParent;
  const SexEdit({ Key? key, required this.notifyParent }) : super(key: key);

  @override
  _SexEditState createState() => _SexEditState();
}

class _SexEditState extends State<SexEdit> {

  final List<String> _sexs = ['男', '女'];
  String _sex = '男'; 
  ProfileService _profileService = ProfileService();
  Profile profile = Profile('', '', '', '', '', '');

  void _getHeight() async {
    profile = await _profileService.getPro();
    print(profile);
    _sex = profile.sex;
    setState(() {
      circle = false;
    });
  }

  bool circle = true;

  @override
  void initState() {
    super.initState();
    _getHeight();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3.0),
      padding: EdgeInsets.all(10.0),
      color: Colors.grey[350],
      child: circle == true
      ? CircularProgressIndicator()
      : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.white,
            child: DropdownButtonFormField(
              items: _sexs.map((String e) =>
                new DropdownMenuItem<String>(
                  value: e,
                  child: Text('   性別: $e', style: TextStyle(fontSize: 18.0)),
                )
              ).toList(),
              onChanged: (String? val) {
                setState(() {
                  _sex = val!;
                });
                print(_sex);
              },
              onSaved: (String? val) {
                setState(() {
                  _sex = val!;
                });
              },
              value: _sex,
            ),
          ),  
          SizedBox(height: 5.0,),                         
          ClipRRect(
            borderRadius: BorderRadius.circular(22.5),
            child: Container(
              width: 100.0,
              height: 35.0,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                ),
                child: Text('Submit', 
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
                onPressed: () async {
                  dynamic result = await _profileService.updateSex(_sex.toString());
                  print(result);      
                  widget.notifyParent();            
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}