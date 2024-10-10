import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:grad_project/components/RateFunction.dart';

class jobRatingService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  jobRatingService(BuildContext context){
    print("test8899");
    showRatingModal(context);
  }
  Future<void> showRatingModal(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    String AccountType;
    String Datafield;
    var documentSnapshot=await firestore.collection("users").doc(uid).get();
    if (documentSnapshot.exists) {
      AccountType="users";
      Datafield="user_uid";
    } else {
      AccountType="workers";
      Datafield="worker_uid";
    }
    await firestore.collection(AccountType).doc(uid).collection("unrated_Jobs").get().then((snapshot) async {

       List<String> templist=[];
      snapshot.docs.forEach((doc) async {
        print(doc.id);
        print("doc.idsss");
        templist.add(doc.id);
     });
      if(templist.isEmpty)
        return;
      else{
        String jobId;
        for (jobId in templist){
         DocumentSnapshot jobdocumentSnapshot= await  firestore.collection('jobs').doc(jobId).get();
         await firestore.collection(AccountType).doc(uid).collection("unrated_Jobs").doc(jobId).delete();
         showRateModal(context, jobId, jobdocumentSnapshot["user_uid"], jobdocumentSnapshot["worker_uid"], jobdocumentSnapshot["user_name"], jobdocumentSnapshot["worker_name"], jobdocumentSnapshot["service"]);

        }


      }


    }); } }