import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/chat_detail_screen.dart';

class HomeOwnerService extends StatefulWidget {

  String area;
  String service;
  String serviceStatus;
  String providerRating;
  String jobId;
  String workerId;
  String userId;
  String workerName;
  String date;

  HomeOwnerService(
      this.userId,
      this.workerId,
      this.jobId,
      this.serviceStatus,
      this.workerName,
      this.area,
      this.providerRating,
      this.service,
      this.date);

  @override
  State<HomeOwnerService> createState() => _HomeOwnerServiceState();
}

class _HomeOwnerServiceState extends State<HomeOwnerService> {
   DocumentSnapshot? userdoc,workerdoc;

  Future messageWorker() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    await FirebaseFirestore.instance.collection('workers').doc(widget.workerId).collection("chat_rooms").doc("${widget.userId}_${widget.workerId}").set({});
    await FirebaseFirestore.instance.collection('users').doc(widget.userId).collection("chat_rooms").doc("${widget.userId}_${widget.workerId}").set({});

    var result =await FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) async {
      await FirebaseFirestore.instance.collection('chatRooms').doc("${widget.userId}_${widget.workerId}").set({
        'user_name':  value['first_name']+" "+value['last_name'],
        'newMessageFromUser_timestamp':0,
        'user_image_url':userdoc?["image_url"],
        'worker_name': widget.workerName,
        'newMessageFromWorker_timestamp':0,
        'worker_image_url':workerdoc?["image_url"],
      });

    });
  }



  Future<bool> getChatroomid()async{
    var doc=await FirebaseFirestore.instance.collection('chatRooms').doc("${widget.userId}_${widget.workerId}").get();
    if(doc.exists)
      return true;
    else
      return false;




  }

   Future getDocs()async{
     userdoc= await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
     workerdoc= await FirebaseFirestore.instance.collection('workers').doc(widget.workerId).get();



   }

  @override
  Widget build(BuildContext context) {
    getDocs();


    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        color: (widget.serviceStatus == 'Active')
            ? Colors.green[200]
            : (widget.serviceStatus == 'Done')
            ? Colors.grey[400]
            : Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(
                  widget.workerName,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.timer),
                  AutoSizeText(
                    widget.date,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.design_services),
              Text(
                widget.service,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            widget.serviceStatus,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 9),
                  child: FloatingActionButton(
                    onPressed: () async {
                     if(await getChatroomid())
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ChatDetailScreen(ChatRoomId:"${widget.userId}_${widget.workerId}",receiverName:widget.workerName,receiverUID: widget.workerId,receiverImage:(workerdoc?["image_url"]==null)?"":workerdoc?["image_url"]);
                        }),
                      );
                     else
                       messageWorker();


                    },
                    child: AutoSizeText(
                      'Message',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 3, color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                ),
              ),(widget.serviceStatus == 'Upcoming')
                  ?
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child:  FloatingActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text(
                              'Are You Sure you Want to Cancel the Appointment'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final DateTime now = DateTime.now();
                                var doc= await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).get();
                                Timestamp firestoreTimestamp = doc['date'];
                                DateTime firestoreDate = firestoreTimestamp.toDate();
                                Duration difference = firestoreDate.difference(now);
                                int hoursDifference = difference.inHours;
                                if(hoursDifference<=12) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                            'You are Unable to Cancel the Service Prior to 12 Hours Before the Appointment Begins'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              // Dismiss the popup and pop the current context
                                              Navigator.of(context).pop();
                                              Navigator.pop(context);
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );




                                }

               else{
                                await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).update(
                                    {"status":"Cancelled"});
                                Navigator.pop(context); }
                              },
                              child: Text('Yes',
                                  style: TextStyle(fontSize: 20)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No',
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: AutoSizeText(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                      maxLines: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 3, color: Colors.red),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: Colors.red,
                  )
                       // Placeholder container when the condition is not met
                ),
              ): Container(),
            ],
          ),
        ],
      ),
    );
  }
}
