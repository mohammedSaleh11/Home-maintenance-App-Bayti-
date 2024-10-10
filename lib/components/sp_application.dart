
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/constants.dart';

class spApplication extends StatelessWidget {
  String uid;
  String first_name;
  String last_name;
  String email;
  String phone_number;
  String gender;
  String city;
  String area;
  String speciality;
  String salary;
  String description;
  String link;


  spApplication(
      this.uid,
      this.first_name,
      this.last_name,
      this.email,
      this.phone_number,
      this.gender,
      this.city,
      this.area,
      this.speciality,
      this.salary,
      this.link,
      this.description
      );
void acceptApplication(){
  FirebaseFirestore.instance.collection('workers').doc(uid).update({
  "application_status":"accepted"
  });
  FirebaseFirestore.instance.collection('workerApplications').doc(uid).delete();

}
  void rejectApplication(){
    FirebaseFirestore.instance.collection('workers').doc(uid).update({
      "application_status":"rejected"
    });
    FirebaseFirestore.instance.collection('workerApplications').doc(uid).delete();


  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
          AutoSizeText.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'First Name:  ',
                  style: profilelabelStyle,
                ),
                TextSpan(
                  text: ' $first_name',
                  style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                ),
                // Add more TextSpan widgets as needed
              ],
            ),
            maxLines: 1, // Adjust the number of lines as needed
          ),

          SizedBox(
            height: 30,
          ),
          AutoSizeText.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'Last Name:  ',
                  style: profilelabelStyle,
                ),
                TextSpan(
                  text: ' $last_name',
                  style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                ),
                // Add more TextSpan widgets as needed
              ],
            ),
            maxLines: 1, // Adjust the number of lines as needed
          ),

          SizedBox(
            height: 30,
          ),
          AutoSizeText.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'Email:  ',
                  style: profilelabelStyle,
                ),
                TextSpan(
                  text: ' $email',
                  style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                ),
                // Add more TextSpan widgets as needed
              ],
            ),
            maxLines: 1, // Adjust the number of lines as needed
          ),

          SizedBox(
            height: 30,
          ),

          AutoSizeText.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'Phone Number:  ',
                  style: profilelabelStyle,
                ),
                TextSpan(
                  text: ' $phone_number',
                  style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                ),
                // Add more TextSpan widgets as needed
              ],
            ),
            maxLines: 1, // Adjust the number of lines as needed
          ),

          SizedBox(
            height: 30,
          ),

          AutoSizeText.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'Gender:  ',
                  style: profilelabelStyle,
                ),
                TextSpan(
                  text: ' $gender',
                  style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                ),
                // Add more TextSpan widgets as needed
              ],
            ),
            maxLines: 1, // Adjust the number of lines as needed
          ),

          SizedBox(
            height: 30,
          ),
          AutoSizeText.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'City:  ',
                  style: profilelabelStyle,
                ),
                TextSpan(
                  text: ' $city',
                  style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                ),
                // Add more TextSpan widgets as needed
              ],
            ),
            maxLines: 1, // Adjust the number of lines as needed
          ),
          SizedBox(
            height: 30,
          ),
          AutoSizeText.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'Area:  ',
                  style: profilelabelStyle,
                ),
                TextSpan(
                  text: ' $area',
                  style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                ),
                // Add more TextSpan widgets as needed
              ],
            ),
            maxLines: 1, // Adjust the number of lines as needed
          ),
          SizedBox(
            height: 30,
          ),
          AutoSizeText.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'Salary:  ',
                  style: profilelabelStyle,
                ),
                TextSpan(
                  text: ' $salary',
                  style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                ),
                // Add more TextSpan widgets as needed
              ],
            ),
            maxLines: 1, // Adjust the number of lines as needed
          ),

          SizedBox(
            height: 30,
          ),
          AutoSizeText.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'Portfolio Link:  ',
                  style: profilelabelStyle,
                ),
                TextSpan(
                  text: ' $link',
                  style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                ),
                // Add more TextSpan widgets as needed
              ],
            ),
            maxLines: 1, // Adjust the number of lines as needed
          ),
          SizedBox(
            height: 30,
          ),

          AutoSizeText.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'speciality:  ',
                  style: profilelabelStyle,
                ),
                TextSpan(
                  text: ' $speciality',
                  style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                ),
                // Add more TextSpan widgets as needed
              ],
            ),
            maxLines: 2, // Adjust the number of lines as needed
          ),

          SizedBox(
            height: 30,
          ),
          AutoSizeText.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'Description:  ',
                  style: profilelabelStyle,
                ),
                TextSpan(
                  text: ' $description',
                  style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                ),
                // Add more TextSpan widgets as needed
              ],
            ),
            maxLines: 10, // Adjust the number of lines as needed
          ),

          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: FloatingActionButton(
                    onPressed: () {

                      acceptApplication();

                    },
                    child: AutoSizeText(
                      'Validate',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 3, color: Colors.green),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 9),
                  child: FloatingActionButton(
                    onPressed: () {
                      rejectApplication();

                    },
                    child: AutoSizeText(
                      'Invalidate',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      side:
                      BorderSide(width: 3, color: Colors.red),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ],
          ),


        ],
      ),
    );

  }
}
