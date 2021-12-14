import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:covid_app/models/blog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlogService {
  final String host = 'http://172.20.10.13:7414';
  Future postBlog(String distance, String time) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var token = _prefs.getString('token');
      String userName = _prefs.getString('name').toString();
      final res = await http.post(Uri.parse('$host/blog/$token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(<String, String>{
          'userName': userName,
          'distance': distance,
          'time': time,
        }));

        if(res.statusCode == 200 || res.statusCode == 201) {
        print(jsonDecode(res.body));
        return (jsonDecode(res.body));
      } else {
        return ('error');
      }  
    } catch (err) {
      print(err);
    }
  }
  
  Future patchImage(String postID, List<String> filesPaths) async {
    var req = http.MultipartRequest('PATCH', Uri.parse('$host/blog/$postID'));
    filesPaths.forEach((e) async { 
      req.files.add(await http.MultipartFile.fromPath("imgs", e));
      print(req.files);  
    });
    req.headers.addAll({
      "Content-Type": "multipart/form-data",
    });
    var res = await req.send();
    return res;
  }

  Future<List<Blog>> getMyPost() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final userName = _prefs.getString('name');
    final res = await http.Client().get(Uri.parse('$host/myblog/$userName'));
    List<Blog> myBlogList = [];
    if(res.statusCode == 200 || res.statusCode == 201) {
      List result = jsonDecode(res.body);
      result.forEach((e) {
        myBlogList.add(
          Blog(
            e['_id'], 
            e['userName'], 
            e['images'], 
            e['distance'], 
            e['time'], 
            e['created_at'], 
            e['collect'] == 'true'
          )
        );
        print(myBlogList[0].images[0]);
      });
    }
    return myBlogList;
  }

  Future deletePost(String postID) async {
    final res = await http.delete(Uri.parse('$host/myblog/$postID'));
    return res.body;
  }

  Future<List<Blog>> getPost(String userName) async {
    final res = await http.Client().get(Uri.parse('$host/myblog/$userName'));
    List<Blog> myBlogList = [];
    if(res.statusCode == 200 || res.statusCode == 201) {
      List result = jsonDecode(res.body);
      result.forEach((e) {
        myBlogList.add(
          Blog(
            e['_id'], 
            e['userName'], 
            e['images'], 
            e['distance'], 
            e['time'], 
            e['created_at'], 
            e['collect'] == 'true'
          )
        );
        print(myBlogList[0].images[0]);
      });
    }
    return myBlogList;
  }

  Future<List<Blog>> getFriendPost() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final userName = _prefs.getString('name');
    final res = await http.Client().get(Uri.parse('$host/blog/$userName'));
    List<Blog> friendBlogList = [];
    if(res.statusCode == 200 || res.statusCode == 201) {
      List result = jsonDecode(res.body);
      result.forEach((e) {
        friendBlogList.add(
          Blog(
            e['_id'], 
            e['userName'], 
            e['images'], 
            e['distance'], 
            e['time'], 
            e['created_at'], 
            e['collect'] == 'true'
          )
        );
      });
    }
    return friendBlogList;
  }  
  
  Future collect(String postID, bool collect) async {
    try {
      final res = await http.post(Uri.parse('$host/blog/collect/$postID'),
      headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(<String, String>{
          'collect': collect.toString(),
        })
      );
      if(res.statusCode == 200 || res.statusCode == 201) {
        return 'success';
      }
    } catch(err) {
      return 'fail';
    }
  }

  Future<List<Blog>> getFavoritePost() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final userName = _prefs.getString('name');
    final res = await http.Client().get(Uri.parse('$host/blog/favorite/$userName'));
    List<Blog> favoriteBlogList = [];
    if(res.statusCode == 200 || res.statusCode == 201) {
      List result = jsonDecode(res.body);
      result.forEach((e) {
        favoriteBlogList.add(
          Blog(
            e['_id'], 
            e['userName'], 
            e['images'], 
            e['distance'], 
            e['time'], 
            e['created_at'], 
            e['collect'] == 'true'
          )
        );
      });
    }
    return favoriteBlogList;
  }  

}