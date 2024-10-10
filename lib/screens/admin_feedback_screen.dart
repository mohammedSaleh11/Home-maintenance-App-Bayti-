import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/feedback_card.dart';



class feedbacksPage extends StatefulWidget {


  @override
  State<feedbacksPage> createState() => _feedbacksPageState();
}

class _feedbacksPageState extends State<feedbacksPage> {
    List<QueryDocumentSnapshot>? jobDocuments=[];
bool isloaded=false;
getJobDetails() async{
  if(isloaded==false){

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('jobs').where("worker_feedback",isNotEqualTo: "").get();

  List<QueryDocumentSnapshot> list1 = querySnapshot.docs.toList();
  QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance.collection('jobs').where("user_feedback",isNotEqualTo: "").get();

  List<QueryDocumentSnapshot> list2 = querySnapshot2.docs.toList();
  List<QueryDocumentSnapshot> combinedList  = [...list1, ...list2];
  List<QueryDocumentSnapshot> uniqueList= combinedList.toSet().toList();

  setState(() {
    jobDocuments = uniqueList;
    isloaded=true;
  });



}}

  @override
  Widget build(BuildContext context) {
    getJobDetails();


    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding:  EdgeInsets.only(left: 16,right: 16,top: 10),
                child: Text(
                  'FeedBacks',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            ListView.builder(
              itemCount: jobDocuments?.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context,index){
                return FeedbackContainer(
                  jobDocuments![index].id,
                  jobDocuments?[index]["user_feedback"],
                  jobDocuments?[index]["worker_feedback"],
                  jobDocuments![index]["user_job_rating"].toString(),
                  jobDocuments![index]["worker_job_rating"].toString(),
                  jobDocuments?[index]["user_name"],
                  jobDocuments?[index]["worker_name"],
                  jobDocuments![index]["date"].toDate().toString(),
                  jobDocuments?[index]["service"],
                  jobDocuments?[index]["area"],
                  jobDocuments?[index]["user_uid"],
                  jobDocuments?[index]["worker_uid"],
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
