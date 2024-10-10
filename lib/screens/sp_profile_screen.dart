import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/profile_image_utils.dart';
import 'package:grad_project/constants.dart';
import 'package:grad_project/screens/Login_Screen.dart';
import 'package:grad_project/screens/sp_edit_profile_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grad_project/screens/edit_profile_screen.dart';

import '../auth/main_page.dart';

class spProfilePage extends StatefulWidget {
  @override
  State<spProfilePage> createState() => _spProfilePageState();
}

late DocumentSnapshot tempdocumentSnapshot;
final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final uid = user?.uid;

class _spProfilePageState extends State<spProfilePage> {
  Uint8List? image_picked;
  late DocumentSnapshot documentSnapshot;
  bool isLoaded=false;
  getCurrWorkerDetails() async{




    var result =await FirebaseFirestore.instance.collection("workers").doc(uid).get().then((value) {
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
    try{
 getCurrWorkerDetails();
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
                child: AutoSizeText(
                  'Profile',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                ),
              ),
              CircleAvatar(
                radius: 64,
                backgroundImage: documentSnapshot['image_url'] != ""
                    ? NetworkImage(documentSnapshot['image_url'])
                    : NetworkImage('https://icons.iconarchive.com/icons/papirus-team/papirus-status/512/avatar-default-icon.png'),),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                ),
                child:Column(
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
                            text: 'Email: ',
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
                            text: 'status:',
                            style: profilelabelStyle,
                          ),
                          TextSpan(
                            text: ' ${documentSnapshot['status']}',
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
                            text: 'Salary: ',
                            style: profilelabelStyle,
                          ),
                          TextSpan(
                            text: '${documentSnapshot['hourly_rate']}',
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
                            text: 'Specialty(ies): ',
                            style: profilelabelStyle,
                          ),
                          TextSpan(
                            text: '"${documentSnapshot['speciality']}"',
                            style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17,),
                          ),
// Add more TextSpan widgets as needed
                        ],
                      ),
                      maxLines: 3, // Adjust the number of lines as needed
                    ),





                    SizedBox(height: 8.0),
                    AutoSizeText.rich(
                      TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'phone Number:  ',
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
                            text: 'City: ',
                            style: profilelabelStyle,
                          ),
                          TextSpan(
                            text: '${documentSnapshot['city']}',
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
                            text: 'area: ',
                            style: profilelabelStyle,
                          ),
                          TextSpan(
                            text: '${documentSnapshot['area']}',
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
                            text: '${documentSnapshot['job_count'].toStringAsFixed(0)}',
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
                      margin:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: FloatingActionButton(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 3, color: Colors.blue),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return spEditProfile(document: documentSnapshot,);
                              }),
                            );
                          }),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: FloatingActionButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          backgroundColor: Colors.red,
                          child: AutoSizeText(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text('Are you sure you want to sign out?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) =>  Login_Screen()));

                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => Login_Screen()));
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
    ); }
        catch(e){return Center(child: CircularProgressIndicator());}
  }
}
