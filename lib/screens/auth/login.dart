import 'package:flutter/material.dart';
import 'package:covid_app/screens/home/loading.dart';
import 'package:covid_app/screens/auth/signup.dart';
import 'package:email_validator/email_validator.dart';
import 'package:covid_app/services/auth.dart';
import 'package:covid_app/screens/home/home.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = '';
  String password = '';
  String emailError = '';
  String passwordError = '';

  Auth _auth = Auth();

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
                      Text('WELCOME BACK', 
                        style:TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        )
                      ,),
                      SizedBox(height: 50.0),
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
                          } return null;
                        },
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                        ), 
                      ),
                      Text(emailError, style: TextStyle(color: Colors.red, fontSize: 18.0),),
                      SizedBox(height: 15.0,),
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
                            passwordError =  '';
                          });    
                          return null;
                        }, 
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      Text(passwordError, style: TextStyle(color: Colors.red, fontSize: 18.0),),
                      SizedBox(height: 35.0,),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          width: 250,
                          height: 50,
                          color: Color.fromARGB(255, 246, 195, 100),
                          child: InkWell(
                            child: Center(child: Text('登入', style: TextStyle(color: Colors.white, fontSize: 24.0))),
                            onTap: () async {
                              if(_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result = await _auth.login(email.trim(), password.trim());
                                print(result);
                                setState(() {
                                  loading = false;
                                });
                                print(result);
                                if(result['user'] == null || result['user'] == '') {
                                  setState(() {
                                    emailError = result['email'];
                                    passwordError = result['password'];
                                  });
                                } else {
                                  print(result['user']);
                                  print(result['name']);
              
                                  Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context) => Home()), (route) => false);
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                        }, 
                        child: Text('註冊', 
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      )
                    ],
                  )),
            ),
          ),
        );
  }
}