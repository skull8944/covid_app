import 'package:covid_app/models/profile.dart';
import 'package:covid_app/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BlogList extends StatefulWidget {
  final String userName;
  final String date;
  final List imgUrls;
  final String distance;
  final String time;
  const BlogList({ Key? key, required this.userName, required this.date, required this.imgUrls, required this.distance, required this.time }) : super(key: key);

  @override
  _BlogListState createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {

  String imgUrl = '';
  ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _getImgUrl();
    print(widget.userName);
    print(widget.imgUrls);
  }

  void _getImgUrl() async {
    final res = await _profileService.getPro();
    setState(() {
      imgUrl = res.imgUrl;
    });    
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
                      backgroundImage: NetworkImage('$imgUrl'),
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
                          Text(widget.userName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                          Text(widget.date, style: TextStyle(color: Colors.grey[700], fontSize: 10.5),)
                        ],
                      ),
                      InkWell(
                        child: Icon(Icons.location_on_sharp, color: Colors.grey[700], size: 35.0,),
                        onTap: () {

                        },
                      ),
                    ],
                  ),
                  trailing: InkWell(
                    child: Icon(Icons.turned_in_not_outlined, color: Colors.grey[700], size: 35.0,),
                    onTap: () {

                    },
                  ),
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                        _currentIndex = index;
                      },
                    );
                  },
                ),
                items: widget.imgUrls.map(
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
                              'http://172.20.10.13:7414/${item.replaceAll(r'\', r'/')}',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.imgUrls.map((urlOfItem) {
                  int index = widget.imgUrls.indexOf(urlOfItem);
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
                children: <Widget>[
                  Text('中正紀念堂'),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: SvgPicture.asset('assets/img/time.svg', color: Colors.grey[750], width: 15, height: 15,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Text(widget.time, style: TextStyle(color: Colors.grey[750]),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: SvgPicture.asset('assets/img/distance.svg', color: Colors.grey[750],),
                        ),
                        Text(widget.distance, style: TextStyle(color: Colors.grey[750]),),
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