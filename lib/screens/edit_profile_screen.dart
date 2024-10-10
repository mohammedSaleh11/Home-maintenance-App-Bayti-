import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/FormTextField.dart';
import 'package:grad_project/components/FormTextFieldController.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:grad_project/components/profile_image_utils.dart';
import 'package:grad_project/constants.dart';
import 'package:validatorless/validatorless.dart';

import 'App_state_screen.dart';
import 'home_screen.dart';

class EditProfile extends StatefulWidget {
  DocumentSnapshot document;
  EditProfile({ Key? key,required this.document}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
 String? image_picked ;
  String? selectedCity="Amman";
  List<String> cities = [
    'Amman',
    'Irbid',
    'Zarqa',
    'Aqaba',
    'Salt',
    'Jarash',
    'karak',
    'Madaba',
  ];

 Uint8List? img ;
bool is_file_uploaded =false;
  void selectImage()async{
   var temp = await pickImage(ImageSource.gallery);
    setState(()  {
      is_file_uploaded = true;
      img = temp;
    });

  }
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  String? validate(String? value) {
    return null;


  }
  
  Future<void> UpdateUserInfo(String firstName, String lastName, String email, String city, String area,Uint8List? image) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          content: Text(
              'Please Wait Until Your Data is Succesfully Updated..'),


        );
      },
    );

    try{

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
await FirebaseFirestore.instance.collection("users").doc(uid).update(
        {   "first_name":firstName,
            "last_name":lastName,
            "email":email,
            "city":city,
            "area":area
        });
    print("string is:");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("chatRooms").get();
    print("string is:2");
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      String documentId = documentSnapshot.id;
      print("string is3:");
      // Check if the first 3 letters of the document ID match the given prefix

      print(documentId.substring(0, documentId.indexOf('_')));
      if (documentId.substring(0, documentId.indexOf('_')) == uid) {
        print("string is4:");
        await FirebaseFirestore.instance.collection("chatRooms")
            .doc(documentId)
            .update({
          "user_name": firstName +"  "+ lastName
          // Add more fields as needed
        });
      }
    }
     querySnapshot = await FirebaseFirestore.instance.collection("jobs").get();
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      // Check if the first 3 letters of the document ID match the given prefix
      if (documentSnapshot["user_uid"]==uid) {
        // Update the specified field in the document
        await FirebaseFirestore.instance.collection("jobs")
            .doc(documentSnapshot.id)
            .update({
          "user_name": firstName +"  "+ lastName
          // Add more fields as needed
        });
      }
    }

    print(img);
    if(image !=null){
      print("image uploaded!");
      uploadImage(image); }
    Navigator.of(context).pop();
    }
    catch(e) {
      Navigator.of(context).pop();
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          content: Text(
              'A Problem Occured With The Server'),
          actions: [
            TextButton(
              onPressed: () {
                // Dismiss the popup and pop the current context
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],


        );
      },
    );}

  }

  Future<void> uploadImage(Uint8List imageFile) async {
   // try {
    print("test1");
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user?.uid;
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage.ref().child('images/$uid.jpg');
      UploadTask uploadTask = storageReference.putData(imageFile);
    print("test2");

      String downloadUrl = await storageReference.getDownloadURL();
        image_picked=downloadUrl;

    print("test3");
      FirebaseFirestore.instance.collection("users").doc(uid).update({
      "image_url":downloadUrl,


      });
    print("test4");
      var querySnapshot = await FirebaseFirestore.instance.collection("chatRooms").get();
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        if (document.id.substring(0, document.id.indexOf("_")) == uid)
          FirebaseFirestore.instance.collection("chatRooms")
              .doc(document.id)
              .update({
            "user_image_url": downloadUrl,
          });
      }
    print("test5");
   // } catch (e) {
    //  print('Error uploading image: $e');
    //}
  }


  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController  = TextEditingController();
  final TextEditingController emailController  = TextEditingController();
  final TextEditingController cityController  = TextEditingController();
  final TextEditingController areaController  = TextEditingController();


  @override
  Widget build(BuildContext context) {
    image_picked = widget.document["image_url"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,

          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RawScrollbar(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),

              child: Column(

                children: <Widget>[

                  SizedBox(height: 20,),
                  Stack(
                    children: <Widget>[


                  is_file_uploaded?
                      CircleAvatar(
                        radius: 64,
                        backgroundImage:   MemoryImage(img!) ):
                      CircleAvatar(
                                            radius: 64,
                    backgroundImage: image_picked != ""
                        ? NetworkImage(image_picked!)
                        :NetworkImage('https://icons.iconarchive.com/icons/papirus-team/papirus-status/512/avatar-default-icon.png'),),


                      Positioned(
                        child: IconButton(
                       onPressed:selectImage,
                          icon: Icon(Icons.add_a_photo),
                        ),
                        bottom: -10,
                        left: 80,
                      )
                    ],
                  ),
                  SizedBox(height: 30,),

                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        FormTextFieldController('First Name:${widget.document["first_name"]}',Icon(Icons.person),firstnameController,true,false,validate),
                        SizedBox(height: 20,),
                        FormTextFieldController('Last Name:${widget.document["last_name"]}',Icon(Icons.person),lastnameController,true,false,validate),
                        SizedBox(height: 20,),
                        FormTextFieldController('Email:${widget.document["email"]}',Icon(Icons.email),emailController,true,false,validate),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          child: DropdownButtonFormField<String>(
                            items: cities.map(
                                  (String DropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  child: Text(DropDownStringItem),
                                  value: DropDownStringItem,
                                );
                              },
                            ).toList(),

                            onChanged: (val) {
                              setState(() {
                                selectedCity=val;
                                cityController.text =selectedCity!;
                              });
                            },
                            value: selectedCity,
                            decoration: InputDecoration(
                              labelText: 'City',
                              labelStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: Icon(Icons.location_city,),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 3.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        FormTextFieldController('area:${widget.document["area"]}',Icon(Icons.location_on),areaController,true,false,validate),
                        SizedBox(height: 20,),






                        Container(
                          width: double.infinity,


                          margin: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                          child: FloatingActionButton(
                            backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,

                                ),
                              ),
                              onPressed: () async{
                               if(firstnameController.text.trim().isEmpty&&lastnameController.text.trim().isEmpty&&emailController.text.trim().isEmpty&&cityController.text.trim().isEmpty&&areaController.text.trim().isEmpty&&img==null)
                                 Navigator.pop(context);
                               else{
                                 await UpdateUserInfo(
                                  firstnameController.text.trim().isEmpty ? "${widget.document["first_name"]}" : firstnameController.text.trim(),
                                  lastnameController.text.trim().isEmpty ? "${widget.document["last_name"]}" : lastnameController.text.trim(),
                                  emailController.text.trim().isEmpty ? "${widget.document["email"]}" : emailController.text.trim(),
                                  cityController.text.trim().isEmpty ? "${widget.document["city"]}" : cityController.text.trim(),
                                  areaController.text.trim().isEmpty ? "${widget.document["area"]}" : areaController.text.trim(),
                                  img
                                );
                                  Navigator.pop(context);
                                 Navigator.pushReplacement(
                                     context,
                                     MaterialPageRoute(builder: (context) =>  myAppState(Page: 'users',)));

                               }

                                }



                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
