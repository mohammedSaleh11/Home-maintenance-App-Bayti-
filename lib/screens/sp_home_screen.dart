import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/job_card.dart';
import '../models/JobRatingService.dart';
import '../models/jobService.dart';

class spHomePage extends StatefulWidget {
  @override
  State<spHomePage> createState() => _spHomePageState();
}

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final uid = user?.uid;

class _spHomePageState extends State<spHomePage> {
  List<Map<String, dynamic>?> JobOffersList = [];
  List<String> JobOffersId = [];
  bool isLoaded = true;

  void getFavWorker() async {
    if (isLoaded) {
      isLoaded = false;
      List<Map<String, dynamic>?> templist = [];

      var result = await FirebaseFirestore.instance
          .collection("workers")
          .doc(uid)
          .collection("job_offers")
          .get();

      result.docs.forEach((document) {
        JobOffersId.add(document.reference.id);
      });

      for (int i = 0; i < JobOffersId.length; i++) {
        var result = await FirebaseFirestore.instance
            .collection("jobs")
            .doc(JobOffersId[i])
            .get()
            .then((value) async {
          var temp = value.data();
          DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(temp?["user_uid"]).get();
          temp?["name"] = documentSnapshot["first_name"] +
              " " +
              documentSnapshot["last_name"];
          temp?["rating"] =
              documentSnapshot["rating"].toStringAsFixed(2);
          temp?["area"] = documentSnapshot["area"];
          temp?["id"] = JobOffersId[i];
          templist.add(temp);
          Timestamp timestamp = temp?["date"];
          DateTime dateTime = timestamp.toDate();
          String formattedDateTime =
          DateFormat('yyyy-MM-dd').format(dateTime);

          temp?["date"] = formattedDateTime;

          templist.add(temp);
        });
      }
      print("templist");
      print(templist);
      if (JobOffersId.isEmpty) JobOffersId = ["000", "000"];
      print("chatRoomsIDsis" + JobOffersId.toString());
      setState(() {
        JobOffersList = templist;
      });
      return null;
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    jobRatingService jobratingservice =jobRatingService(context);
    jobService jobservice =jobService();
    getFavWorker();
    print("hellooooooo");
    return Scrollbar(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30),
                child: AutoSizeText(
                  'New Appointments',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: JobOffersId.isNotEmpty
                    ?
                FirebaseFirestore.instance
                    .collection('jobs')
                    .where(FieldPath.documentId, whereIn: JobOffersId)
                    .where("status", isEqualTo: "Waiting Acceptance")
                    .snapshots()
                    : null,
                builder: (context, snapshot) {


                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.hasError||!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var sortedDocuments = snapshot.data!.docs;
                  List<Map<String, dynamic>?> joblist = [];
                  for (int i = 0; i < sortedDocuments.length; i++) {
                    var jobData =
                    sortedDocuments[i].data() as Map<String, dynamic>;

                    jobData["id"] = JobOffersId[i];

                    Timestamp timestamp = jobData["date"];
                    DateTime dateTime = timestamp.toDate();
                    String formattedDateTime =
                    DateFormat('yyyy-MM-dd').format(dateTime);

                    jobData["date"] = formattedDateTime;
                    joblist.add(jobData);
                  }
                  List<Widget> jobWidgets = [];
                  for (var job in joblist) {
                    final jobWidget = jobCard(
                      job?["user_uid"],
                      uid!,
                      job?["id"],
                      job?["status"],
                      job?["worker_name"],
                      job?["user_name"],
                      job?["date"].toString(),
                      job?["service"].toString(),
                      job?["area"],
                      job?["user_rating"],
                    );

                    print(job.toString());
                    jobWidgets.add(jobWidget);
                  }
                  return (jobWidgets.isNotEmpty)
                      ? ListView.builder(
                    itemCount: jobWidgets.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return jobWidgets[index];
                    },
                  )
                      : Container(
                    height: MediaQuery.of(context).size.height * 0.6, // Adjust the height as needed

                    child: Center(
                                            child: AutoSizeText(
                        "You Don't have any New Appointments",
                        style: TextStyle(fontSize: 20),
                                         textAlign: TextAlign.center,   ),
                                          ),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}