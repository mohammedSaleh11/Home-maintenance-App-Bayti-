import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grad_project/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

void showRateModal(BuildContext context, String JobId, String UserId, String WorkerId,String UserName,String WorkerName,String? Service) {
  double selectedRating = 2.5;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;
  String userType=(uid==WorkerId)?"worker":"user";

  TextEditingController feedbackController = TextEditingController();
Future<void> UpdateNewRatingAndJobDetails(double rating, String feedback) async {
  print(uid);
  print(WorkerId);
if(uid==WorkerId){

 var userSnapshot= await FirebaseFirestore.instance.collection('users').doc(UserId).get();
 double? old_rating;
 double? old_jobCount;
 int? temp;
 double? temp2;

 if (userSnapshot.exists && userSnapshot.data() != null ) {
   temp=userSnapshot.data()!['job_count'].toInt();
   old_jobCount=temp?.toDouble();
   temp2= userSnapshot.data()!['rating'];
   old_rating=temp2?.toDouble();
   print("test11");
   }
 print(old_rating);
 print(old_jobCount);
 print((old_rating!*old_jobCount!));
 print(rating);
 print((old_rating+1));
 double? new_rating=((old_rating!*old_jobCount!)+rating)/(old_jobCount+1);
  await FirebaseFirestore.instance.collection('users').doc(UserId).update(
      {"rating":new_rating,
        'job_count':old_jobCount+1,
      }
  );
 await FirebaseFirestore.instance.collection('jobs').doc(JobId).update({
   "worker_job_rating":rating,
   "worker_feedback":feedback



 });


}
else{
  print("test11");
  var workerSnapshot= await FirebaseFirestore.instance.collection('workers').doc(WorkerId).get();
double? old_rating;
double? old_jobCount;
int? temp;
  double? temp2;
  print("test12");
if (workerSnapshot.exists && workerSnapshot.data() != null) {
  print("test13");
  temp=workerSnapshot.data()!['job_count'].toInt();
  print("test14");
  old_jobCount=temp?.toDouble();
  print("test15");
  temp2= workerSnapshot.data()!['rating'];
  print("test16");
  old_rating=temp2?.toDouble();
  print("test17");
double? new_rating=((old_rating!*old_jobCount!)+rating)/(old_jobCount+1);
  print("test18");
await FirebaseFirestore.instance.collection('workers').doc(WorkerId).update(
    {"rating":new_rating,
      'job_count':old_jobCount+1,
    }
);
  print("test19");
await FirebaseFirestore.instance.collection('jobs').doc(JobId).update({
  "user_job_rating":rating,
  "user_feedback":feedback



});
  print("test20");
  ;}}





}

  showModalBottomSheet(

    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(

      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child:AutoSizeText.rich(
                  TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Rate ',
                        style: profilelabelStyle,
                      ),
                      TextSpan(
                        text: (userType=="worker")?UserName:WorkerName,
                        style: TextStyle(fontStyle: FontStyle.italic,fontSize: 20),
                      ),
                      // Add more TextSpan widgets as needed
                    ],
                  ),
                  maxLines: 1, // Adjust the number of lines as needed
                ),

              ),
              SizedBox(
                height: 10,
              ),
              (userType=='user')?
              Center(
                child:AutoSizeText.rich(
                  TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Service: ',
                        style: profilelabelStyle,
                      ),
                      TextSpan(
                        text: Service,
                        style: TextStyle(fontStyle: FontStyle.italic,fontSize: 20),
                      ),
                      // Add more TextSpan widgets as needed
                    ],
                  ),
                  maxLines: 1, // Adjust the number of lines as needed
                ),

              ):
              Center(
                child:AutoSizeText.rich(
                  TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Location: ',
                        style: profilelabelStyle,
                      ),
                      TextSpan(
                        text: "test",
                        style: TextStyle(fontStyle: FontStyle.italic,fontSize: 20),
                      ),
                      // Add more TextSpan widgets as needed
                    ],
                  ),
                  maxLines: 1, // Adjust the number of lines as needed
                ),

              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    selectedRating = rating;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  controller: feedbackController,
                  decoration: InputDecoration(
                    labelText: 'feedback(optional)',
                    labelStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
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
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 3, color: Colors.blue),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  onPressed: () {
                    print("selectedRating");
                    print(selectedRating);
                    print("feedbackController.text");
                    print(feedbackController.text);
                   UpdateNewRatingAndJobDetails(selectedRating,feedbackController.text);

                    Navigator.pop(context);
                  },
                  child: Text(
                    'finish',
                    style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'skip',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18.0,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
