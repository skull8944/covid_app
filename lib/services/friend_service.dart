import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FriendService {
  final String host = 'http://172.20.10.13:7414';
  Future addFriend(String userName2) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? userName = _prefs.getString('name');
    final res = await http.post(Uri.parse('$host/friend/add/$userName/$userName2'));
    if(res.statusCode == 200 || res.statusCode == 201) {
      return 'success';
    } else {
      return 'fail';
    }
  }

  Future acceptRequest(String userName2) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? userName = _prefs.getString('name');
    final res = await http.post(Uri.parse('$host/friend/accept/$userName/$userName2'));
    if(res.statusCode == 200 || res.statusCode == 201) {
      return 'success';
    } else {
      return 'fail';
    }
  }

  Future rejectRequest(String userName2) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? userName = _prefs.getString('name');
    final res = await http.post(Uri.parse('$host/friend/reject/$userName/$userName2'));
    if(res.statusCode == 200 || res.statusCode == 201) {
      return 'success';
    } else {
      return 'fail';
    }
  }

  Future<List> getFriends() async {   
    List friends = [];
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? userName = _prefs.getString('name');
    final res = await http.Client().get(Uri.parse('$host/friend/friends/$userName'));
    if(res.statusCode == 200 || res.statusCode == 201) {
      List freindList = jsonDecode(res.body);
      friends = freindList;
      print(friends[0]['requester']);
    }

    return friends;
  }

  Future<List> getFriendRequests() async {
    List friendRequests = [];
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? userName = _prefs.getString('name');
    final res = await http.Client().get(Uri.parse('$host/friend/friend_requests/$userName'));
    if(res.statusCode == 200 || res.statusCode == 201) {
      friendRequests = jsonDecode(res.body);
    }    

    return friendRequests;
  }

  Future<int> getFriendStatus(userName2) async {
    int friendStatus = 0;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? userName = _prefs.getString('name');
    final res = await http.Client().get(Uri.parse('$host/friend/friend_status/$userName/$userName2'));
    if(res.statusCode == 200 || res.statusCode == 201) {
      friendStatus = int.parse(res.body);
    } 

    return friendStatus;
  }

}