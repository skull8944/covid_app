import 'package:covid_app/models/profile.dart';
import 'package:covid_app/services/profile_service.dart';
import 'package:flutter/material.dart';

class WeightEdit extends StatefulWidget {
  final Function() notifyParent;
  const WeightEdit({ Key? key, required this.notifyParent  }) : super(key: key);

  @override
  _WeightEditState createState() => _WeightEditState();
}

class _WeightEditState extends State<WeightEdit> {

  double _weight = 70.0;
  ProfileService _profileService = ProfileService();
  Profile profile = Profile('', '', '', '', '');

  void _getWeight() async {
    profile = await _profileService.getPro();
    print(profile);
    _weight = double.parse(profile.weight);
    setState(() {
      circle = false;
    });
  }

  bool circle = true;

  @override
  void initState() {
    super.initState();
    _getWeight();
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
          Text('$_weight kg', style: TextStyle(fontSize: 20.0),),
          Slider(
            value: _weight,
            min: 40.0,
            max: 100.0,
            divisions: 120,
            label: _weight.toString(),
            onChanged: (val) {
              setState(() {
                _weight = val;
              });
            },
          ),              
          SizedBox(height: 15.0,),        
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
                  dynamic result = await _profileService.updateWeight(_weight.toString());
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