
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../screens/chat_detail_screen.dart';
import 'RateFunction.dart';


class jobCard extends StatefulWidget {
  String? appointment_time;
  String? service;
  String rating;
  String location;

  String jobStatus;

  String userId;
  String workerId;
  String jobId;
  String workerName;
  String userName;


  jobCard(this.userId,this.workerId,this.jobId,this.jobStatus,this.workerName,this.userName,this.appointment_time,this.service,this.location, this.rating,);

  @override
  State<jobCard> createState() => _jobCardState();
}
final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final uid = user?.uid;
class _jobCardState extends State<jobCard> {

  int numberOfRatings = 0;
  double totalRating = 0.0;
  double selectedRating=0.0;
  bool hasRated=false;
  late DocumentSnapshot userdoc;
  late DocumentSnapshot workerdoc;
  Future messageUser() async{
    print("test1");
    await FirebaseFirestore.instance.collection('workers').doc(widget.workerId).collection("chat_rooms").doc("${widget.userId}_${widget.workerId}").set({});
    print("test2");
    await FirebaseFirestore.instance.collection('users').doc(widget.userId).collection("chat_rooms").doc("${widget.userId}_${widget.workerId}").set({});
    print("test3");
    print(widget.userId);
    print(widget.workerId);
    userdoc= await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
    print("test3.5");
    workerdoc= await FirebaseFirestore.instance.collection('workers').doc(widget.workerId).get();
    print("test4");
    var result =await FirebaseFirestore.instance.collection("workers").doc(uid).get().then((value) async {
      await FirebaseFirestore.instance.collection('chatRooms').doc("${widget.userId}_${widget.workerId}").set({
        'user_name':  widget.userName,
        'newMessageFromUser_timestamp':0,
        'user_image_url':userdoc["image_url"],
        'worker_name':value['first_name']+" "+value['last_name'],
        'newMessageFromWorker_timestamp':0,
        'worker_image_url':workerdoc["image_url"],
      });
      print("test5");
    });
    print("test6");
  }












  final GlobalKey<FormState> myWidgetKey = GlobalKey();


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
          color:
         (widget.jobStatus == 'Active') ? Colors.green[200] :
        (widget.jobStatus == 'Done') ? Colors.grey[400] :Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              child: AutoSizeText(
                (uid==widget.workerId)?'${widget.userName}':'${widget.workerName}',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.date_range),
                  Text(
                    '${widget.appointment_time}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    '${(widget.rating=="0.00")? 5:widget.rating}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 35,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.handyman),
                  Text(
                    '${widget.service}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.location_on),
              Text(
                '${widget.location}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          (widget.jobStatus != 'New') ?Text(
            widget.jobStatus,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ):Container(),
          SizedBox(height: 6,),

          Row(
            children: [
              Expanded(
                child: Container(
                  child: FloatingActionButton(
                    onPressed: () async {
                      if(await getChatroomid()){
                        print("heelo");
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                      return ChatDetailScreen(ChatRoomId:"${widget.userId}_${widget.workerId}",receiverName:widget.userName,receiverUID: widget.userId,receiverImage:(userdoc["image_url"]==null)?"":userdoc["image_url"]);
                      }),
                      );}
                      else{
                      messageUser();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ChatDetailScreen(ChatRoomId:"${widget.userId}_${widget.workerId}",receiverName:widget.userName,receiverUID: widget.userId,receiverImage:(userdoc["image_url"]==null)?"":userdoc["image_url"]);
                        }),
                      );
                      } },
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
              ),
              (widget.jobStatus == 'Active') ?Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 9),
                  child: FloatingActionButton(
                    onPressed: () {

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text(
                              'Are you sure that you are done with the job?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                print("test2");
                                print(widget.jobId);
                                await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).update(
                                    {"status":"Done"});
                                print("test2");
                                Navigator.pop(context);
                                if (context.mounted) {

                                  showRateModal(
                                      context,
                                      widget.jobId,
                                      widget.userId,
                                      widget.workerId,
                                      widget.userName,
                                      widget.workerName,
                                      widget.service);
                                }
                                await  FirebaseFirestore.instance.collection('users').doc(widget.userId).collection("unrated_Jobs").doc(widget.jobId).set({});




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
                      'End',
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
              ):Container(),
            ],
          ),

          (widget.jobStatus == 'Waiting Acceptance') ?  Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: FloatingActionButton(

                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(

                            content: Text(
                                'You Accepted a New Job Successfully!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Dismiss the popup and pop the current context
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],


                          );
                        },
                      );
                      print("widget.jobId");
                      print(widget.jobId);
                        await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).update(
                            {"status":"Upcoming"});
                      var result = await FirebaseFirestore.instance.collection("workers").doc(
                          uid).collection("job_offers").doc(widget.jobId).delete();


                    },
                    child: AutoSizeText(
                      'Accept',
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
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(

                            content: Text(
                                'You Rejected a Job Offer.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Dismiss the popup and pop the current context
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],


                          );
                        },
                      );
                      await FirebaseFirestore.instance.collection("jobs").doc(widget.jobId).delete();
                      await FirebaseFirestore.instance.collection("workers").doc(widget.workerId).collection("job_offers").doc(widget.jobId).delete();



                    },
                    child: AutoSizeText(
                      'Reject',
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
          ):Container(),




        ],
      ),
    );
  }
}
