import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


pickImage(ImageSource source)async{
  final ImagePicker pickedImage = ImagePicker();
  XFile? filePicked =await pickedImage.pickImage(source: source);

  if(filePicked!=null){
    return await filePicked.readAsBytes();
  }
  print('No Image Selected!');

}