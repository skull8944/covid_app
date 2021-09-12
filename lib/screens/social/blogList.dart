import 'package:covid_app/screens/home/loading.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BlogList extends StatefulWidget {
  final String userName;
  final String date;
  final List<String> imgUrls;
  const BlogList({ Key? key, required this.userName, required this.date, required this.imgUrls }) : super(key: key);

  @override
  _BlogListState createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {

  final List<String> imagesList = [
    'https://cdn.pixabay.com/photo/2020/11/01/23/22/breakfast-5705180_1280.jpg',
    'https://cdn.pixabay.com/photo/2019/01/14/17/25/gelato-3932596_1280.jpg',
    'https://cdn.pixabay.com/photo/2017/04/04/18/07/ice-cream-2202561_1280.jpg',
  ];

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
                      backgroundImage: NetworkImage('https://stickershop.line-scdn.net/stickershop/v1/product/3349339/LINEStorePC/main.png;compress=true'),
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
                items: imagesList.map(
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
                              item,
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
                children: imagesList.map((urlOfItem) {
                  int index = imagesList.indexOf(urlOfItem);
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Color.fromRGBO(0, 0, 0, 0.8)
                          : Color.fromRGBO(0, 0, 0, 0.3),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}