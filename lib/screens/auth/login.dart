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
                      CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.white,
                        child: Center(child: Text('logo'),),
                      ),
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
                        SizedBox(height: 15.0,),
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
                              hintText: 'Password',
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
                        SizedBox(height: 35.0,),
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
                                'Log In', 
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
                      ],
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
                        'Need an Account? Sign up!', 
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 20
                        ),                          
                      ),
                      InkWell(
                        child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[600],),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
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