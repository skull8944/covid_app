import 'dart:convert';
import 'package:covid_app/models/profile.dart';
import 'package:covid_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  
  final String host = "http://120.114.170.16:7414";

  Future uploadProfile(String sex, String height, String weight, String birthdate) async {
    try {
      SharedPreferences prefs =  await SharedPreferences.getInstance();
      var name = prefs.getString('name');
      final res = await http.post(Uri.parse('$host/user_profile/$name'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(<String, String>{
          'sex': sex,
          'height': height,
          'weight': weight,
          'birthdate': birthdate
        }));

      if(res.statusCode == 200 || res.statusCode == 201) {
        return 'success';
      } else {
        return 'fail';
      }   
    } catch(err) {
      print(err);
      return 'error';
    }
  }

  Future getProfile() async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    var name = prefs.getString('name');
    final res = await http.Client().get(Uri.parse('$host/user_profile/$name'));
    print('$host/user_profile/$name');
    if(res.statusCode == 200 || res.statusCode == 201) {
      var result = jsonDecode(res.body);
      String imgUrl = host + '/' + result['headshot'].replaceAll(r'\', r'/');
      Profile profile = Profile(name!, result['sex'], result['height'], result['weight'], result['birthdate'], imgUrl);
      return profile;
    } else {
      return 'no data';
    }      
  }
  
  Future<Profile> getPro() async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    var name = prefs.getString('name');
    final res = await http.Client().get(Uri.parse('$host/user_profile/$name'));
    Profile profile = Profile('', '','','','','');
    if(res.statusCode == 200 || res.statusCode == 201) {
      var result = jsonDecode(res.body);
      String imgUrl = host + '/' + result['headshot'].replaceAll(r'\', r'/');
      profile = Profile(name!, result['sex'], result['height'], result['weight'], result['birthdate'], imgUrl);
      return profile;
    } else {
      return profile;  
    }  
  }

  Future<Profile> getFriendPro(String name) async {
    final res = await http.Client().get(Uri.parse('$host/user_profile/$name'));
    Profile profile = Profile('', '','','','','');
    if(res.statusCode == 200 || res.statusCode == 201) {
      var result = jsonDecode(res.body);
      String imgUrl = host + '/' + result['headshot'].replaceAll(r'\', r'/');
      profile = Profile(name, result['sex'], result['height'], result['weight'], result['birthdate'], imgUrl);
      return profile;
    } else {
      return profile;  
    }  
  }

  Future patchImage(String filepath) async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    var name = prefs.getString('name');

    var req = http.MultipartRequest('PATCH', Uri.parse('$host/user_profile/addimg/$name'));
    req.files.add(await http.MultipartFile.fromPath("img", filepath));
    req.headers.addAll({
      "Content-Type": "multipart/form-data",
    });
    var res = req.send();
    return res;
  }

  Future getUser() async {
    try{
      SharedPreferences prefs =  await SharedPreferences.getInstance();
      var name = prefs.getString('name');
      final res = await http.Client().get(Uri.parse('$host/user/$name'));
      if(res.statusCode == 200 || res.statusCode == 201) {
        var result = jsonDecode(res.body);
        User user = User(result['name'], result['name'], result['email']);
        return user;
      }
    } catch(err) {
      return err;
    }    
  }
  
  Future updateHeight(String height) async {
    try {
      SharedPreferences prefs =  await SharedPreferences.getInstance();
      var name = prefs.getString('name');
      final res = await http.post(Uri.parse('$host/user_profile/height_edit/$name'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(<String, String>{
          'height': height,
        }));

      if(res.statusCode == 200 || res.statusCode == 201) {
        return (jsonDecode(res.body));
      } else {
        return ('error');
      }   
    } catch(err) {
      print(err);
    }
  }

  Future updateWeight(String weight) async {
    try {
      SharedPreferences prefs =  await SharedPreferences.getInstance();
      var name = prefs.getString('name');
      final res = await http.post(Uri.parse('$host/user_profile/weight_edit/$name'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(<String, String>{
          'weight': weight,
        }));

      if(res.statusCode == 200 || res.statusCode == 201) {
        return (jsonDecode(res.body));
      } else {
        return ('error');
      }   
    } catch(err) {
      print(err);
    }
  }

  Future updateSex(String sex) async {
    try {
      SharedPreferences prefs =  await SharedPreferences.getInstance();
      var name = prefs.getString('name');
      final res = await http.post(Uri.parse('$host/user_profile/sex_edit/$name'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(<String, String>{
          'sex': sex,
        }));

      if(res.statusCode == 200 || res.statusCode == 201) {
        return (jsonDecode(res.body));
      } else {
        return ('error');
      }   
    } catch(err) {
      print(err);
    }
  }

  Future updateBirthdate(String birthdate) async {
    try {
      SharedPreferences prefs =  await SharedPreferences.getInstance();
      var name = prefs.getString('name');
      final res = await http.post(Uri.parse('$host/user_profile/birthdate_edit/$name'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(<String, String>{
          'birthdate': birthdate,
        }));

      if(res.statusCode == 200 || res.statusCode == 201) {
        return (jsonDecode(res.body));
      } else {
        return ('error');
      }   
    } catch(err) {
      print(err);
    }
  }

  Future<List<Profile>> getUserSuggestions(String query) async {
    final res = await http.Client().get(Uri.parse('$host/user_profile/suggestions/$query'));
    List<Profile> suggsetions = [];
    if(res.statusCode == 200 || res.statusCode == 201) {      
      Map<String, dynamic> usersMap = jsonDecode(res.body);
      List users = usersMap.values.toList();
      users.forEach((e) {
        suggsetions.add(
          Profile(e[0]['userName'], '', '', '', '', '$host/' + e[0]['headshot'].toString().replaceAll(r'\', r'/'))
        );
      });    
    }    
    return suggsetions;
  }

}