import 'package:covid_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:covid_app/services/profile_service.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({ Key? key }) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _profileService = ProfileService();
  
  final List<String> _sexs = ['男', '女'];
  String _sex = '男'; 
  double _height = 160.0; 
  double _weight = 50.0; 
  String birthDateInString = '';
  DateTime birthDate = DateTime(2000);
  final _picker = ImagePicker();
  File? file;
  var filePath;
  String birthDateError = '';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '設定資料', 
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color.fromARGB(255, 246, 195, 100),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50.0,),
              Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 65.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: file != null
                      ? FileImage(file!)
                      : null
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[850],
                        size: 28.0,
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: ((builder) => bottomSheet()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35.0,),
              Container(
                width: 200.0,
                child: DropdownButtonFormField(
                  items: _sexs.map((String e) =>
                      new DropdownMenuItem<String>(
                      value: e,
                      child: Text('性別: $e', style: TextStyle(fontSize: 17.0)),
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
              SizedBox(height: 15.0,),
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
              SizedBox(height: 10.0,),
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
              Text('Birthdate: $birthDateInString', style: TextStyle(fontSize: 20.0),),
              SizedBox(height: 20.0,),
              GestureDetector(
                child: new Icon(Icons.calendar_today_outlined, size: 25.0,),
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
              Text(birthDateError, style: TextStyle(color: Colors.red, fontSize: 25.0),),
              SizedBox(height: 20.0,),
              ClipRRect(
                borderRadius: BorderRadius.circular(22.5),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.07,
                  color: Color.fromARGB(255, 246, 195, 100),
                  child: TextButton(
                    child: Text(
                      '更改', 
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w600,
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
                        dynamic result = await _profileService.uploadProfile(_sex, _height.toString(), _weight.toString(), birthDateInString);
                        print(result);
                        if(result != 'wrong') {
                          if(filePath != null) {
                            dynamic imgResult = await _profileService.patchImage(filePath);
                            print(imgResult);
                            Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context) => Home()), (route) => false);
                          } else {
                            Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context) => Home()), (route) => false);
                          }
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
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
              onPressed: () {
                getImage(ImageSource.camera);
              },
              label: Text("Camera", style: TextStyle(color: Colors.grey[700], fontSize: 20),),
            ),
            TextButton.icon(
              icon: Icon(Icons.image, color: Colors.grey[700],),
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              label: Text("Gallery", style: TextStyle(color: Colors.grey[700], fontSize: 20),),
            ),
          ])
        ],
      ),
    );
  }
}

