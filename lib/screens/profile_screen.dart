import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/profile_image_utils.dart';
import 'package:grad_project/constants.dart';
import 'package:grad_project/screens/Login_Screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grad_project/screens/edit_profile_screen.dart';

import '../auth/main_page.dart';


class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? image_picked;
late DocumentSnapshot documentSnapshot;
bool isLoaded=false;

 getCurrUserDetails() async{

   late DocumentSnapshot tempdocumentSnapshot;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;


 var result =await FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
     tempdocumentSnapshot=value; }
);
 //result.docs.forEach((element) {
//templist.add(element.data());

 //});
setState(() {
  documentSnapshot=tempdocumentSnapshot;
isLoaded=true;
});


}




  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    setState(() {});
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
    builder: (context, snapshot) {
      try{
        var documentSnapshot = snapshot.data!.data() as Map<String, dynamic>;
         print("sss");
        return RawScrollbar(
          thumbVisibility: true,
          thumbColor: Colors.grey,
          radius: Radius.circular(20),
          thickness: 6,
          child: SingleChildScrollView(
            child: Center(
              child: Column(







                children: <Widget>[

                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,

                      ),
                    ),
                  ),
                  documentSnapshot['image_url'] == ""
                      ?
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage('images/avatar-default-icon.png'),
                  ):
                  CircleAvatar(
                    radius: 64,
                    backgroundImage:  NetworkImage(documentSnapshot['image_url']+'?timestamp=${DateTime.now().millisecondsSinceEpoch}')
                        ),









                  Container(
                    margin:   EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black,
                        width: 4,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText.rich(
                          TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'First Name: ',
                                style: profilelabelStyle,
                              ),
                              TextSpan(
                                text: '${documentSnapshot['first_name']}',
                                style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                              ),

                              // Add more TextSpan widgets as needed
                            ],
                          ),
                          maxLines: 1, // Adjust the number of lines as needed
                        ),
                        SizedBox(height: 8.0),

                        AutoSizeText.rich(
                          TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Last Name: ',
                                style: profilelabelStyle,
                              ),
                              TextSpan(
                                text: '${documentSnapshot['last_name']}',
                                style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17,),
                              ),
                              // Add more TextSpan widgets as needed
                            ],
                          ),
                          maxLines: 1, // Adjust the number of lines as needed
                        ),
                        SizedBox(height: 8.0),

                        AutoSizeText.rich(
                          TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Email:',
                                style: profilelabelStyle,
                              ),
                              TextSpan(
                                text: '${documentSnapshot['email']}',
                                style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17,),
                              ),
                              // Add more TextSpan widgets as needed
                            ],
                          ),
                          maxLines: 1, // Adjust the number of lines as needed
                        ),



                        SizedBox(height: 8.0),


                        AutoSizeText.rich(
                          TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'City: ',
                                style: profilelabelStyle,
                              ),
                              TextSpan(
                                text: ' ${documentSnapshot['city']}',
                                style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                              ),
                              // Add more TextSpan widgets as needed
                            ],
                          ),
                          maxLines: 1, // Adjust the number of lines as needed
                        ),
                        SizedBox(height: 8.0),

                        AutoSizeText.rich(
                          TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Area: ',
                                style: profilelabelStyle,
                              ),
                              TextSpan(
                                text: '${documentSnapshot['area']}',
                                style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17,),
                              ),
                              // Add more TextSpan widgets as needed
                            ],
                          ),
                          maxLines: 1, // Adjust the number of lines as needed
                        ),
                        SizedBox(height: 8.0),



                        AutoSizeText.rich(
                          TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Phone Number:  ',
                                style: profilelabelStyle,
                              ),
                              TextSpan(
                                text: '${documentSnapshot['phone_number']}',
                                style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                              ),
                              // Add more TextSpan widgets as needed
                            ],
                          ),
                          maxLines: 1, // Adjust the number of lines as needed
                        ),
                        SizedBox(height: 8),
                        AutoSizeText.rich(
                          TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Gender: ',
                                style: profilelabelStyle,
                              ),
                              TextSpan(
                                text: '${documentSnapshot['gender']}',
                                style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                              ),
                              // Add more TextSpan widgets as needed
                            ],
                          ),
                          maxLines: 1, // Adjust the number of lines as needed
                        ),
                        SizedBox(height: 8.0),
                        AutoSizeText.rich(
                          TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Rating:  ',
                                style: profilelabelStyle,
                              ),
                              TextSpan(
                                text: '${documentSnapshot['rating'].toStringAsFixed(2)}',
                                style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                              ),
                              // Add more TextSpan widgets as needed
                            ],
                          ),
                          maxLines: 1, // Adjust the number of lines as needed
                        ),
                        SizedBox(height: 8.0),
                        AutoSizeText.rich(
                          TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Job Count:  ',
                                style: profilelabelStyle,
                              ),
                              TextSpan(
                                text: '${documentSnapshot['job_count']?.toInt() }',
                                style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                              ),
                              // Add more TextSpan widgets as needed
                            ],
                          ),
                          maxLines: 1, // Adjust the number of lines as needed
                        ),

                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                          child: FloatingActionButton(

                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 3,color: Colors.blue),
                                borderRadius: BorderRadius.circular(25),

                              ),

                              backgroundColor: Colors.white,
                              child: AutoSizeText(
                                'Edit Account',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,

                                  color: Colors.black,

                                ),
                                maxLines: 1,
                              ),
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return EditProfile(document:snapshot.data!);
                                  }),
                                );

                              }
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(


                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: FloatingActionButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              backgroundColor: Colors.red,
                              child: Text(
                                'Sign Out',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,

                                ),
                              ),
                              onPressed: (){

                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Text('Are you sure you want to sign out?'),
                                    actions: [
                                      TextButton(

                                        onPressed: () {
                                          Navigator.pop(context);
                                          print("signing out");
                                          print(FirebaseAuth.instance.currentUser?.uid);
                                          FirebaseAuth.instance.signOut();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  Login_Screen()));
                                        },
                                        child: Text('Yes',style: TextStyle(fontSize: 20),),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);

                                        },
                                        child: Text('No',style: TextStyle(fontSize: 20),),
                                      ),
                                    ],
                                  ),
                                );



                              }

                          ),
                        ),
                      ),
                    ],
                  ),




                ],
              ),
            ),
          ),
        );}
      catch(e){return Center(child: CircularProgressIndicator());}







    } );
  }
}
