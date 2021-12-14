import 'package:covid_app/models/profile.dart';
import 'package:covid_app/services/profile_service.dart';
import 'package:flutter/material.dart';

class BirthdateEdit extends StatefulWidget {
  final Function() notifyParent;
  const BirthdateEdit({ Key? key, required this.notifyParent }) : super(key: key);

  @override
  _BirthdateEditState createState() => _BirthdateEditState();
}

class _BirthdateEditState extends State<BirthdateEdit> {
  DateTime birthDate = DateTime(2000);
  String birthDateInString = '';
  String birthDateError = '';
  ProfileService _profileService = ProfileService();
  Profile profile = Profile('', '', '', '', '', '');

  void _getHeight() async {
    profile = await _profileService.getPro();
    birthDateInString = profile.birthdate;
    print(birthDateInString);
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
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      color: Colors.grey[350],
      child: circle == true
        ? CircularProgressIndicator()
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [            
            Text('生日: $birthDateInString', style: TextStyle(fontSize: 20.0),),
            SizedBox(height: 10.0,),
            GestureDetector(
              child: new Icon(Icons.calendar_today_outlined, size: 30.0, color: Colors.blue,),
              onTap: ()async{
                final datePick = await showDatePicker(
                  context: context,
                  initialDate: new DateTime(2000),
                  firstDate: new DateTime(1950),
                  lastDate: new DateTime(DateTime.now().year)
                );
                if(datePick != null && datePick != birthDate){
                  setState(() {
                    birthDate = datePick;
                    birthDateInString = datePick != null ? "${birthDate.year}/${birthDate.month}/${birthDate.day}" : '請選擇日期';       
                    print(birthDate);   
                    print(birthDateError);            
                  });
                }
              }
            ),
            Text(birthDateError, style: TextStyle(color: Colors.red, fontSize: 15.0),),           
            ClipRRect(
              borderRadius: BorderRadius.circular(22.5),
              child: Container(
                width: 100.0,
                height: 40.0,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                  ),
                  child: Text(
                    '更改', 
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                  onPressed: () async {
                    if(birthDateInString == '' || birthDateInString == '請選擇日期') {
                      setState(() {
                        birthDateError = '請按上方按鈕選擇日期!';
                      });
                    } else {
                      setState(() {
                        birthDateError = '';
                      });                      
                      dynamic result = await _profileService.updateBirthdate(birthDateInString.toString());
                      print(result);
                      widget.notifyParent();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
    );
  }
}