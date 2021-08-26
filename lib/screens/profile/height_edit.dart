import 'package:covid_app/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/services/profile_service.dart';

class HeightEdit extends StatefulWidget {
  final Function() notifyParent;
  const HeightEdit({ Key? key, required this.notifyParent }) : super(key: key);

  @override
  _HeightEditState createState() => _HeightEditState();
}

class _HeightEditState extends State<HeightEdit> {
  
  double _height = 160.0;
  ProfileService _profileService = ProfileService();
  Profile profile = Profile('', '', '', '', '');

  void _getHeight() async {
    profile = await _profileService.getPro();
    print(profile);
    _height = double.parse(profile.height);
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
          Text('$_height cm', style: TextStyle(fontSize: 20.0),),
          Slider(
            value: _height,
            min: 140.0,
            max: 200.0,
            divisions: 120,
            label: _height.toString(),
            onChanged: (val) {
              setState(() {
                _height = val;
              });
            },
          ),
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
                  dynamic result = await _profileService.updateHeight(_height.toString());
                  widget.notifyParent();
                  print(result);
                },
              ),
            ),
          ),
        ],
      )
  );
  }
}