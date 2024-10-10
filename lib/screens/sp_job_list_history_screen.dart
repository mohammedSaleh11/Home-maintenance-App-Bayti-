import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/job_card.dart';
import 'package:intl/intl.dart';
class jobListHistory extends StatelessWidget {
  const jobListHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final currentUid = user?.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            // Handle the action for the existing leading IconButton
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Old Jobs',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [

        ],
      ),

      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
//chatRoomsIDs.contains(FirebaseFirestore.instance.collection("chatRooms").doc().id) .orderBy("worker_lastActive",descending:false)
                //stream:FirebaseFirestore.instance.collection('chatRooms').doc("yMUmRWl2lbXez88DHIgExMUoLI72_workertest").collection("messages").orderBy("time",descending:false).snapshots(),
                stream: FirebaseFirestore.instance.collection('jobs').where("worker_uid", isEqualTo:currentUid ).where("status",isEqualTo: "Done").snapshots(),
                builder: (context, snapshot) {


                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }


                  var sortedDocs = snapshot.data!.docs;
                  sortedDocs.sort((a, b) => (b['date'] as Timestamp)
                      .compareTo(a['date'] as Timestamp));


                  List<Map<String, dynamic>?> joblist = [];
                  for(int i=0;i<sortedDocs.length;i++) {
                    var jobData=sortedDocs[i].data() as Map<String, dynamic>;
                    jobData["id"]=sortedDocs[i].id;
                    Timestamp timestamp = jobData["date"];
                    DateTime dateTime = timestamp.toDate();
                    String formattedDateTime = DateFormat('yyyy-MM-dd').format(dateTime);
                    jobData["date"]=formattedDateTime;
                    joblist.add(jobData);
                  }
                  List<Widget> jobWidgets = [];
                  for(var job in joblist){
                    final jobWidget=  jobCard(job?["user_uid"],currentUid!,job?["id"],job?["status"],job?["worker_name"],job?["user_name"],job?["date"].toString(),job?["service"].toString(),job?["area"],job!["user_rating"].toString());


                    print(job.toString());
                    jobWidgets.add(jobWidget);
                  }
                  return (jobWidgets.isNotEmpty)?

                    ListView.builder(
                    itemCount: jobWidgets.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                      return jobWidgets[index];
                    },
                  ):Container(
                      height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed

                      child: Center(child: AutoSizeText("You Have not Done any Jobs Yet",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,)));



                },
              ),


              // ListView.builder(
              //   itemCount: 4,
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemBuilder: (context,index){
              //     return jobCard('userid',"workerid",'jobid','Upcoming','username','time',"price","location","4.4");
              //
              //   },
              // ),

            ],
//             child: StreamBuilder<QuerySnapshot>(
// //chatRoomsIDs.contains(FirebaseFirestore.instance.collection("chatRooms").doc().id) .orderBy("worker_lastActive",descending:false)
//               //stream:FirebaseFirestore.instance.collection('chatRooms').doc("yMUmRWl2lbXez88DHIgExMUoLI72_workertest").collection("messages").orderBy("time",descending:false).snapshots(),
//               stream: FirebaseFirestore.instance.collection('jobs').where(FieldPath.documentId, whereIn:JobOffersId ).where("status",isEqualTo: "Waiting Acceptance") .snapshots(),
//               builder: (context, snapshot) {
//
//
//                 if (!snapshot.hasData) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//
//                 var sortedDocuments = snapshot.data!.docs;
//                 List<Map<String, dynamic>?> joblist = [];
//                 for(int i=0;i<sortedDocuments.length;i++) {
//                   var jobData=sortedDocuments[i].data() as Map<String, dynamic>;
//
//                   jobData["id"]=JobOffersId[i];
//
//                   Timestamp timestamp = jobData["date"];
//                   DateTime dateTime = timestamp.toDate();
//                   String formattedDateTime = DateFormat('yyyy-MM-dd').format(dateTime);
//
//                   jobData["date"]=formattedDateTime;
//                   joblist.add(jobData);
//                 }
//                 List<Widget> jobWidgets = [];
//                 for(var job in joblist){
//                   final jobWidget=  jobCard(job?["user_uid"],uid!,job?["id"],job?["status"],job?["user_name"],job?["date"].toString(),"20",job?["area"],job?["user_rating"]);
//
//
//                   print(job.toString());
//                   jobWidgets.add(jobWidget);
//                 }
//                 return ListView.builder(
//                   itemCount: jobWidgets.length,
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemBuilder: (context,index){
//                     return jobWidgets[index];
//                   },
//                 );
//
//
//
//               },
//             ),




          ),
        ),
      ),
    );
  }
}
