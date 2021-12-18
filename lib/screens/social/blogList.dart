import 'package:covid_app/models/blog.dart';
import 'package:covid_app/screens/running/running_marks.dart';
import 'package:covid_app/services/blog_service.dart';
import 'package:covid_app/services/geolocator_service.dart';
import 'package:covid_app/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlogList extends StatefulWidget {
  final Blog blog;
  final Function deletePost;

  BlogList({Key? key, required this.blog, required this.deletePost }) : super(key: key);
  @override
  _BlogListState createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  final host = 'http://172.20.10.13:7414/';
  bool showMore = false;
  String myName = '';
  String imgUrl = '';
  ProfileService _profileService = ProfileService();
  BlogService _blogService = BlogService();
  bool collectState = false;
  GeolocatorService _geolocatorService = GeolocatorService();

  void getMyName()  async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      myName = _prefs.getString('name')!;
    });    
  }

  @override
  void initState() {    
    super.initState();
    setState(() {
      collectState = widget.blog.collect;
    });
    getMyName();
    _getImgUrl();
  }

  void _getImgUrl() async {
    final res = await _profileService.getFriendPro(widget.blog.userName);
    if(mounted) {
      setState(() {
        imgUrl = res.imgUrl;
      });          
    }
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28.0),
      child: Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              Container(
                color: Color.fromARGB(255, 236, 236, 239),
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: InkWell(
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(imgUrl),
                    ),
                    onTap: () {
                      
                    },
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.blog.userName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                          Text(widget.blog.updatedTime.substring(0,10), style: TextStyle(color: Colors.grey[700], fontSize: 10.5),)
                        ],
                      ),
                      InkWell(
                        child: Icon(Icons.location_on_sharp, color: Colors.grey[700], size: 35.0,),
                        onTap: () async {
                          List<LatLng> marks = await _geolocatorService.getMarks(widget.blog.runRecordId);
                          showDialog(
                            context: context, 
                            builder: (BuildContext context) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,      
                              width: MediaQuery.of(context).size.width * 0.9,                
                              child: Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                insetPadding: EdgeInsets.zero,
                                child: RunningMarks(marks: marks,)
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  trailing: myName == widget.blog.userName
                  ? InkWell(
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: Colors.grey[700], size: 35.0,
                    ),
                    onTap: () async {
                      setState(() {
                        showMore = !showMore;
                      });
                    },
                  )
                  : InkWell(
                    child: Icon(
                      collectState
                      ? Icons.turned_in_outlined
                      : Icons.turned_in_not_rounded,
                      color: Colors.grey[700], size: 35.0,
                    ),
                    onTap: () async {
                      dynamic result = await _blogService.collect(widget.blog.postID, !collectState);
                      if(result == 'success') {
                        setState(() {
                          collectState = !collectState;
                        });
                      }
                    },
                  )
                ),
              ),
              Stack(
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        setState(() {
                            _currentIndex = index;
                          },
                        );
                      },
                    ),
                    items: widget.blog.images.map(
                      (item) =>  Card(
                        semanticContainer: true,
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          child: Container(
                            child: Stack(
                              children: <Widget>[
                                Image.network(
                                  host + item.replaceAll(r'\', r'/'),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                  ),
                  showMore 
                    ? Positioned(
                      right: 0,
                      child: InkWell(
                        child:ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
                            color: Colors.white,
                            child: Row(
                              children: [
                                Icon(Icons.delete_rounded, size: 25,),
                                Text('Delete', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 14),),
                              ],
                            ),
                          ),
                        ),
                        onTap: () => showDialog(
                          context: context, 
                          builder: (BuildContext context) => AlertDialog(
                            content: Text(
                              '確定刪除此貼文?', 
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20
                              ),),
                            actions: <Widget>[
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Text(
                                    '確定',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.green
                                    ),
                                  )
                                ),
                                onTap: () async {
                                  final res = await _blogService.deletePost(widget.blog.postID);
                                  print(res);
                                  setState(() {
                                    showMore = false;
                                  });
                                  if(res == 'success') {                            
                                    widget.deletePost(widget.blog.postID);
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Text(
                                    '取消',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.red
                                    ),
                                  )
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          )
                        ),
                      ),
                    )
                    : Container(width: 0, height: 0,)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.blog.images.map((urlOfItem) {
                  int index = widget.blog.images.indexOf(urlOfItem);
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin: EdgeInsets.symmetric( horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                        ? Color.fromRGBO(0, 0, 0, 0.8)
                        : Color.fromRGBO(0, 0, 0, 0.3),
                    ),
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: SvgPicture.asset('assets/img/time.svg', color: Colors.grey[750], width: 15, height: 15,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Text(widget.blog.time, style: TextStyle(color: Colors.grey[750]),),
                        ),
                      ],
                    )
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: SvgPicture.asset('assets/img/distance.svg', color: Colors.grey[750],),
                        ),
                        Text(widget.blog.distance+'km', style: TextStyle(color: Colors.grey[750]),),
                      ],
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}