import 'package:flutter/material.dart';

class BlogView extends StatefulWidget {
  final String userName;
  final String context;
  final List<String> imgUrls;
  const BlogView({ Key? key, required this.userName, required this.context, required this.imgUrls }) : super(key: key);

  @override
  _BlogViewState createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(),
              TextButton(
                child: Icon(Icons.ac_unit_outlined),
                onPressed: () {
                  
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}