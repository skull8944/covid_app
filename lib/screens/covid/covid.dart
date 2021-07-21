import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Covid extends StatefulWidget {
  const Covid({ Key? key }) : super(key: key);

  @override
  _CovidState createState() => _CovidState();
}

class _CovidState extends State<Covid> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: WebView(
          initialUrl: 'https://www.google.com/maps/d/u/0/embed?mid=1rrk8w7jJsZGXz_hSpi0q9no77cdhMC2z&ll=22.992360212133317%2C120.19757256053016&z=13',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      )
    );
  }
}