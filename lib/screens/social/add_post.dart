import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AddPost extends StatefulWidget {
  const AddPost({ Key? key }) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  ImagePicker _imagePicker = ImagePicker();
  List<XFile>? imgList = [];
  bool pickable = true;

  Future pickImages() async {
    if(imgList!.length <= 5) {
      final pickedImages = await _imagePicker.pickMultiImage();
    }    
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20)
      ),
      child: Container(
        color: Colors.grey[200],
        height: MediaQuery.of(context).size.height *0.7,
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Add Post', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
          ],        
        ),
      ),
    );
  }
}