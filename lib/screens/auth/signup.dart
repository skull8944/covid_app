import 'package:flutter/material.dart';
import 'package:covid_app/screens/home/loading.dart';
import 'package:covid_app/screens/auth/login.dart';
import 'package:email_validator/email_validator.dart';
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
                          return '';
                        } else if(val.length > 8) {
                          setState(() {
                            nameError = '請輸入長度小於8的名字';
                          });
                          return '';
                        } 
                        setState(() {
                          nameError = '';
                        });
                        return null;                        
                      },
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                    ),
                    Text(nameError, style: TextStyle(color: Colors.red, fontSize: 18.0),),
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
                        if(val!.isEmpty) {
                          setState(() {
                            emailError = '請輸入email';
                          });
                          return '';
                        } else if(EmailValidator.validate(val) == false) {
                          setState(() {
                            emailError = '請輸入有效的email';
                          });
                          return '';
                        } 
                        setState(() {
                          emailError = '';
                        });
                        return null;
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
                          if(val!.isEmpty) {
                            setState(() {
                              passwordError ='請輸入密碼';
                            }); 
                            return '';
                          }                        
                          else if(val.length < 6) {
                            setState(() {
                              passwordError =  '請輸入長度大於6的密碼';
                            });    
                            return '';
                          }
                          setState(() {
                            passwordError = '';
                          });
                          return null;
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        width: 250,
                        height: 50,
                        color: Color.fromARGB(255, 246, 195, 100),
                        child: InkWell(
                          child: Center(child: Text('註冊', style: TextStyle(color: Colors.white, fontSize: 24.0))),
                          onTap: () async {
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
                                  nameError = result['name'];
                                });
                              } else {
                                Navigator.pop(context, new MaterialPageRoute(builder: (context) => Login()));
                              }
                            }
                          },
                        ),
                      ),
                    ),                    
                    SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
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