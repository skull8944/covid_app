import 'package:flutter/material.dart';
import 'package:covid_app/screens/loading.dart';
import 'package:covid_app/screens/auth/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:covid_app/models/user.dart';
import 'package:covid_app/services/auth.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Auth _auth = Auth();
  
  bool loading = false;
  String email = '';
  String password = '';
  String name = '';
  String emailError = '';
  String passwordError = '';
  String nameError = '';

  User user = User('', '');

  @override
  Widget build(BuildContext context) {
    return loading
      ? Loading()
      : Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 80.0,),
                    CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Color.fromARGB(100, 159, 159, 160),
                    ),
                    SizedBox(height: 40.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Name',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey[700]
                        ),
                      )
                    ),
                    TextFormField(
                      //name
                      validator: (val) {
                        if(val!.isEmpty){
                          setState(() {
                            nameError = '請輸入名字';
                          });
                        }else{
                          setState(() {
                            nameError = val.length <= 8 ? '' : '請輸入長度小於8的名字';
                          });
                        }
                      },
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                    ),
                    Text(emailError, style: TextStyle(color: Colors.red, fontSize: 18.0),),
                    SizedBox(
                      height: 15.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Email',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey[700]
                        ),
                      )
                    ),
                    TextFormField(
                      //email
                      validator: (val) {
                        if(val!.isEmpty){
                          setState(() {
                            emailError = '請輸入email';
                          });
                        }else{
                          setState(() {
                            emailError = (EmailValidator.validate(val) == true) ? '' : '請輸入有效的email';
                          });
                        }
                      },
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    Text(emailError, style: TextStyle(color: Colors.red, fontSize: 18.0),),
                    SizedBox(
                      height: 15.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Password',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey[700]
                        ),
                      )
                    ),
                    TextFormField(
                      //password                       
                      obscureText: true,
                      validator: (val) {
                        if(val!.isEmpty)
                          setState(() {
                            passwordError ='請輸入密碼';
                          });                         
                        else
                          setState(() {
                            passwordError = val.length >= 6 ? '' : '請輸入長度大於6的密碼';
                          });    
                      }, 
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    Text(passwordError, style: TextStyle(color: Colors.red, fontSize: 18.0),),
                    SizedBox(
                      height: 35.0,
                    ),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 250.0, height: 50.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if(_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth.signup(email.trim(), password.trim(), name.trim());
                            setState(() {
                              loading = false;
                            });
                            if(result['user'] == null) {
                              setState(() {
                                emailError = result['email'];
                              });
                            } else {
                              Navigator.pop(context, new MaterialPageRoute(builder: (context) => Login()));
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(100, 159, 159, 160)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            )
                          )
                        ),
                        child: Text(
                          '註冊',
                          style: TextStyle(color: Colors.white, fontSize: 24.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context) => Login()), (route) => false);
                      }, 
                      child: Text('登入', 
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600
                        ),
                      )
                    )
                  ],
                )
              ),
            ),
          ),
        );
  }
}