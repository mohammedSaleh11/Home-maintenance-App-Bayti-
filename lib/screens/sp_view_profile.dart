import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:grad_project/constants.dart';



class spViewProfile extends StatelessWidget {
  Uint8List? image_picked;
  Map<String,dynamic> document;
  spViewProfile({required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
        title: AutoSizeText(
          'Service provider information',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          maxLines: 1,
        ),
      ),
      body: RawScrollbar(
        thumbVisibility: true,
        thumbColor: Colors.grey,
        radius: Radius.circular(20),
        thickness: 6,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),


                CircleAvatar(
                  radius: 64,
                  backgroundImage:  document['image_url'] != ""
                      ? NetworkImage( document['image_url'])
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'First Name: ${document["first_name"]} ',
                        style: profilelabelStyle,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Last Name: ${document["last_name"]} ',
                        style: profilelabelStyle,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Email: ${(document["email"] !="")?document["email"]:'(not Set)'}',
                        style: profilelabelStyle,
                      ),
                      SizedBox(
                        height: 30,
                      ),

                      Text(
                        'Gender: ${document["gender"]}',
                        style: profilelabelStyle,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Speciality(ies): ${document["speciality"].toString()}',
                        style: profilelabelStyle,maxLines: 2,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Rating: ${document["rating"].toStringAsFixed(2)}',
                        style: profilelabelStyle,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Status: ${document["status"]}',
                        style: profilelabelStyle,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'jds per hour: ${(document["hourly_rate"] !="" && document["hourly_rate"] !=null)?document["hourly_rate"]:'(not Set)'}',
                        style: profilelabelStyle,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'jobs completed: ${document["job_count"]}',
                        style: profilelabelStyle,
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
