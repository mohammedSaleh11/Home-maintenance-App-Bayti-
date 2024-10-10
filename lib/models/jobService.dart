import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class jobService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  jobService(){
    print("test1");
    updatejobStatus();
  }
  Future<void> updatejobStatus() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    String AccountType;
    String Datafield;
    print("test2");
 var documentSnapshot=await firestore.collection("users").doc(uid).get();
    if (documentSnapshot.exists) {
      AccountType="user";
      Datafield="user_uid";
    } else {
      AccountType="worker";
      Datafield="worker_uid";
    }
   await firestore.collection('jobs').where(Datafield,isEqualTo: uid).get().then((snapshot) {
      final DateTime now = DateTime.now();
      print("test3");
      snapshot.docs.forEach((doc) async {
        print("doc.id");
        print(doc.id);
        Timestamp firestoreTimestamp = doc.data()['date'];
        DateTime firestoreDate = firestoreTimestamp.toDate();
        Duration difference = firestoreDate.difference(now);
        int daysDifference = difference.inDays;
        //cancel offer
        if(doc.data()["status"]=="Waiting Acceptance" && daysDifference<=1){
         await firestore.collection('jobs').doc(doc.id).update({
          "status":"Cancelled"

        });
         print("wating doc");
        print(doc.id);
        }
        //upcoming to active
      if(doc.data()["status"]=="Upcoming" && now.isAfter(firestoreDate) && daysDifference>=-1)
        await  firestore.collection('jobs').doc(doc.id).update({
          "status":"Active"
        }
          );
        //upcoming to done
        if(doc.data()["status"]=="Upcoming" && now.isAfter(firestoreDate) && daysDifference<-1){
          await  firestore.collection('jobs').doc(doc.id).update({
          "status":"Done"
          }
          );
          if(AccountType=="user"){

            await  firestore.collection('users').doc(uid).collection("unrated_Jobs").doc(doc.id).set({});
            await   firestore.collection('workers').doc(doc.data()["worker_uid"]).collection("unrated_Jobs").doc(doc.id).set({});}
          else{
            await   firestore.collection('workers').doc(uid).collection("unrated_Jobs").doc(doc.id).set({});
            await  firestore.collection('users').doc(doc.data()["user_uid"]).collection("unrated_Jobs").doc(doc.id).set({}); }

        }
        //active to done
        if(doc.data()["status"]=="Active" && daysDifference<1) {
          await  firestore.collection('jobs').doc(doc.id).update({
            "status":"Done"
          }

          );
          if(AccountType=="user"){
            await firestore.collection('users').doc(uid).collection("unrated_Jobs").doc(doc.id).set({});
            await  firestore.collection('workers').doc(doc.data()["worker_uid"]).collection("unrated_Jobs").doc(doc.id).set({});}
          else{
            await   firestore.collection('workers').doc(uid).collection("unrated_Jobs").doc(doc.id).set({});
            await  firestore.collection('users').doc(doc.data()["user_uid"]).collection("unrated_Jobs").doc(doc.id).set({}); }
        }
        // Do something with the document data, e.g., access specific fields
        String jobTitle = doc.get('jobTitle');
        String description = doc.get('description');
   });




});} }