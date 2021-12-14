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
        backgroundColor: Color.fromARGB(255, 246, 195, 100),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  color: Color.fromARGB(255, 246, 195, 100),
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('./assets/img/logo.png',scale: 19,),
                    ],
                  ),
                ),    
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35)
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.63,
                    color: Colors.grey[300],
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 149, 148, 149),
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(2.0, 2.0)
                            )
                          ]
                        ),
                        child: TextFormField(
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
                          decoration: InputDecoration(
                            hintText: 'Name',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 0, 
                                style: BorderStyle.none,
                              ),
                            ),
                          ), 
                        ),
                      ),
                      Text(nameError, style: TextStyle(color: Colors.red, fontSize: 18.0),),
                      SizedBox(
                        height: 15.0,
                      ),                      
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 149, 148, 149),
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(2.0, 2.0)
                            )
                          ]
                        ),
                        child: TextFormField(
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
                          decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 0, 
                                style: BorderStyle.none,
                              ),
                            ),
                          ), 
                        ),
                      ),
                      Text(emailError, style: TextStyle(color: Colors.red, fontSize: 18.0),),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 149, 148, 149),
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(2.0, 2.0)
                            )
                          ]
                        ),
                        child: TextFormField(
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
                          decoration: InputDecoration(
                              hintText: '密碼',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: 0, 
                                  style: BorderStyle.none,
                                ),
                              ),
                            ), 
                        ),
                      ),
                        Text(passwordError, style: TextStyle(color: Colors.red, fontSize: 18.0),),
                        SizedBox(
                          height: 35.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.56,
                          height: MediaQuery.of(context).size.height * 0.087,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 246, 195, 100),
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 149, 148, 149),
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(2.0, 2.0)
                              )
                            ]
                          ),
                          child: InkWell(
                            child: Center(
                              child: Text(
                                '註冊', 
                                style: TextStyle(
                                  color: Colors.white, fontSize: 24.0,
                                  fontWeight: FontWeight.w600
                                )
                              )
                            ),
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
                      ]
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '已經有帳號了?現在登入!', 
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 20
                        ),                          
                      ),
                      InkWell(
                        child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[600],),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                )                
              ],
            )
          ),
        ),
      );
  }
}