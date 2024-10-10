
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/profile_image_utils.dart';
import 'package:grad_project/constants.dart';
import 'package:grad_project/screens/Login_Screen.dart';
import 'package:grad_project/screens/sp_edit_profile_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grad_project/screens/edit_profile_screen.dart';
import 'package:grad_project/components/sp_application.dart';

class AdminHome extends StatefulWidget {
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 60),
                child: AutoSizeText(
                  'Applications',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                ),
              ),
              Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      StreamBuilder<QuerySnapshot>(
//chatRoomsIDs.contains(FirebaseFirestore.instance.collection("chatRooms").doc().id) .orderBy("worker_lastActive",descending:false)
                        //stream:FirebaseFirestore.instance.collection('chatRooms').doc("yMUmRWl2lbXez88DHIgExMUoLI72_workertest").collection("messages").orderBy("time",descending:false).snapshots(),
                        stream: FirebaseFirestore.instance.collection('workerApplications').snapshots(),
                        builder: (context, snapshot) {


                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }


                          var Docs = snapshot.data!.docs;




                          List<Widget> applicationWidgets = [];
                          for(var doc in Docs){

                            final applicationWidget=  spApplication(doc.id,doc["first_name"],doc["last_name"],doc["email"],doc["phone_number"],doc["gender"],doc["city"],doc["area"],doc["speciality"].toString() ,doc["hourly_rate"].toString(),doc["link"].toString(),doc["description"]);

                            print("test888");

                            applicationWidgets.add(applicationWidget);
                          }
                          return (applicationWidgets.isNotEmpty)?

                          ListView.builder(
                            itemCount: applicationWidgets.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context,index){
                              return applicationWidgets[index];
                            },
                          ):Container(
                              height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed

                              child: Center(child: AutoSizeText("You Don't have any Applications to Review",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,)));



                        },
                      ),

                    ],

                  ),
                ),
              ),
              // ListView.builder(
              //   itemCount: 4,
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemBuilder: (context,index){
              //     return spApplication('mohammed','tarek','null','0795039713','male',['plumbing','electrical'],'10',"",'im an electricianxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxojhdfidfhidfshgidfshgidugohfgiofghoghodfhgoudihdfigdfsoiuhdidhpigvjkhkfjhgjdshgsjghdfjkghdfjghsdgpdhsgiudshgudrsghdsrugfhfhfhfhfghfghfhgfdhgfdhdfhdfhfdghdfghfdhdfhdfdgdfgdgfgdfdfgdfgdfgfdfdgdfgdfdfgfgfgergergergsdgfwrwgergthrthrthrtht');
              //   },
              // ),

            ],
          ),
        ),
      ),
    );
  }
}
