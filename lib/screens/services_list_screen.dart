import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/homeowner_service_card.dart';
import 'package:grad_project/screens/services_list_history_screen.dart';
import 'package:intl/intl.dart';

import '../components/job_card.dart';
import '../models/jobService.dart';

class servicesList extends StatelessWidget {
  const servicesList({super.key});

  @override
  Widget build(BuildContext context) {
    jobService jobservice =jobService();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final currentUid = user?.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
        title: Text(
          'Upcoming Services',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          // Use the Spacer widget to push the IconButton to the right

          // Add your additional IconButton here
          IconButton(
            onPressed: () { Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => services_list_history_screen()),
            );
            },
            icon: Icon(Icons.work_history, color: Colors.white),
          ),
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
                stream: FirebaseFirestore.instance.collection('jobs').where("user_uid", isEqualTo:currentUid ).where("status",whereIn: ["Upcoming", "Active"]) .snapshots(),
                builder: (context, snapshot) {


                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }


                  var sortedDocs = snapshot.data!.docs;
                  sortedDocs.sort((a, b) => (a['date'] as Timestamp)
                      .compareTo(b['date'] as Timestamp));


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
                    
                    final jobWidget=  HomeOwnerService(job?["user_uid"],job?["worker_uid"],job?["id"],job?["status"],job?["worker_name"] ,job?["area"],job?["worker_rating"],job?["service"],job!["date"].toString());


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
                    child: Center(
                      child: AutoSizeText(
                        "You Don't Have Any Upcoming Services",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );



                },
              ),
              // ListView.builder(
              //   itemCount: 4,
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemBuilder: (context,index){
              //     return HomeOwnerService('active','ahmed tarek','11/2/2024 17:00:00','20 jd','plumbing');
              //   },
              // ),

            ],
          ),
        ),
      ),
    );
  }
}
