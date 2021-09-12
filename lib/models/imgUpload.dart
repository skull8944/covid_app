import 'dart:io';

class ImgUpload {

  bool isUploaded;
  bool uploading;
  File imageFile;
  String imageUrl;

  ImgUpload(
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
  );

}