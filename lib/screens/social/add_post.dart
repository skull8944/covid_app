import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AddPost extends StatefulWidget {
  final String distance;
  final String pace;
  final String calories;
  const AddPost({ Key? key, required this.distance, required this.pace, required this.calories }) : super(key: key);

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
        padding: EdgeInsets.all(14),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(child: Text('Add Post', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),)),
              SizedBox(height: 30,),
              Text('Record:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.26,
                    child: Center(
                      child: Text('13m', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.05,
                    child: VerticalDivider(color: Colors.grey[700], thickness: 4,)
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child:  Center(child: Text('06:12', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),)),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.05,
                    child: VerticalDivider(color: Colors.grey[700], thickness: 4,)
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.26,
                    child: Center(child: Text('132', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),)),
                  ),
                  
                ],
              ),
              SizedBox(height: 30,),
              Text('Post:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
              
            ],        
          ),
        ),
      ),
    );
  }
}