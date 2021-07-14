import 'package:flutter/cupertino.dart';

class Blog {
  String userToken;
  String userName;
  List<Image> images;
  String content;
  String updatedTime;

  Blog(this.userToken , this.userName, this.images, this.content, this.updatedTime);
}