import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:covid_app/services/blog_service.dart';

class AddPost extends StatefulWidget {
  final String runRecordID;
  final String distance;
  final String time;
  final String calories;
  const AddPost({ Key? key,required this.runRecordID, required this.distance, required this.time, required this.calories }) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  
  BlogService _blogService = BlogService();

  List<File> files = [];
  List<String> filesPaths = [];

  int filesLength = 0;

  void _pickImage(BuildContext context) async {
    List<AssetEntity>? assets = await AssetPicker.pickAssets(context, maxAssets: 6 - filesLength);
    if (assets!.length > 0) {
      assets.forEach((e) async {
        File? file = await e.file;
        if(file != null) {
          files.add(file);
          filesPaths.add(file.path);
          setState(() {
            filesLength++;
          });
          print('Assets: $e \t $filesLength');
        }
      });
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
        height: MediaQuery.of(context).size.height * 0.9,
        color: Colors.grey[200],
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Center(child: Text('新增貼文', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),)),
            SizedBox(height: 30,),
            Text('運動紀錄:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
            SizedBox(height: 20,),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('照片:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
                filesLength < 6
                ? InkWell(
                    child: Icon(Icons.photo_library_rounded, color: Colors.grey[600], size: 30,),
                    onTap: () async {
                      _pickImage(context);
                    },
                  )
                : Container(width: 0, height: 0,)
              ],
            ),
            filesLength > 0
            ? Expanded(
              child: Center(
                child: GridView.count(
                  crossAxisCount: 3,
                  children:  files.map((e) => 
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.28,
                              height: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                              child: Image.file(e, fit: BoxFit.cover,),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: InkWell(
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.close_rounded, color: Colors.black,),
                            ),
                            onTap: () {
                              files.remove(e);
                              setState(() {
                                filesLength--;
                              });
                              print(filesLength);
                            },
                          )
                        )
                      ]
                    ),                    
                  ).toList(),
                ),
              ),
            )
            : Container(width: 0, height: 0,),
            filesLength > 0
            ? Center(
                child: InkWell(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      color: Color.fromARGB(255, 246, 195, 100),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Center(child: Text('Share', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600))),
                    ),
                  ),
                  onTap: () async {
                    dynamic res = await _blogService.postBlog(widget.runRecordID, widget.distance, widget.time);
                    print(res['postID']);
                    print(filesPaths);
                    dynamic imgRes = await _blogService.patchImage(res['postID'], filesPaths);
                    print(imgRes);
                    Navigator.pop(context);
                  },
                ),
              )
            : Container(width: 0, height: 0,)
          ],        
        ),
      ),
    );
  }
}