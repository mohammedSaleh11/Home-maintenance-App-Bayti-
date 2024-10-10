
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:grad_project/screens/sp_view_profile.dart';

import '../screens/chat_detail_screen.dart';
import '../screens/chat_screen.dart';


class spCard extends StatefulWidget {
  String provider_name;
  String? status;
  List<dynamic> speciality;
  double? Rating;
  String salary;
  String completed_jobs;
  String provider_uid;
  bool isFavorited;
  var favoriteColor;
  Map<String,dynamic> document;

  spCard(this.provider_name,this.completed_jobs,this.salary,this.status, this.speciality, this.Rating,this.provider_uid,this.isFavorited,this.document);


  @override
  State<spCard> createState() => _spCardState();
}

class _spCardState extends State<spCard> {

  Future addFavorite() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    print(widget.provider_uid);
    await FirebaseFirestore.instance.collection('users').doc(uid).collection("favorite_workers").doc(widget.provider_uid).set({});
    print(widget.provider_uid);

  }
  Future removeFavorite() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;


    print(uid);
    await FirebaseFirestore.instance.collection('users').doc(uid).collection("favorite_workers").doc(widget.provider_uid).delete();
    print(widget.provider_uid);

  }

  Future messageWorker() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    await FirebaseFirestore.instance.collection('workers').doc(widget.provider_uid).collection("chat_rooms").doc("${uid}_${widget.provider_uid}").set({});
    await FirebaseFirestore.instance.collection('users').doc(uid).collection("chat_rooms").doc("${uid}_${widget.provider_uid}").set({});
    print(widget.provider_uid);

    var result =await FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) async {
      await FirebaseFirestore.instance.collection('chatRooms').doc("${uid}_${widget.provider_uid}").set({
          'user_name':  value['first_name']+" "+value['last_name'],
          'user_image_url':value['image_url'],
          'worker_name':widget.provider_name,
          'worker_image_url':widget.document["image_url"],
      });

    });



  }
  





  DateTime ?selectedDateTime=DateTime.now();

  void sendJobOffer(DateTime? selectedDateTime, String selectedService) async{

      print("test2");
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user?.uid;
      // DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(jobData["user_uid"]).get();
      // jobData["name"]=documentSnapshot["first_name"]+" "+documentSnapshot["last_name"];
      // jobData["rating"]=documentSnapshot["rating"].toStringAsFixed(2);
      // jobData["area"]=documentSnapshot["area"];
      // jobData["id"]=JobOffersId[i];
      DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      DocumentSnapshot workerDocumentSnapshot = await FirebaseFirestore.instance.collection('workers').doc(widget.provider_uid).get();
      print("user uid="+uid!);
      print("worker uid="+widget.provider_uid);
      DocumentReference newDocRef = await FirebaseFirestore.instance.collection('jobs').add({
        'worker_uid': widget.provider_uid,
        'worker_name':workerDocumentSnapshot["first_name"]+" "+workerDocumentSnapshot["last_name"],
        'worker_rating':workerDocumentSnapshot["rating"].toStringAsFixed(2),
        'user_uid': uid,
        'user_name':userDocumentSnapshot["first_name"]+" "+userDocumentSnapshot["last_name"],
        'user_rating':userDocumentSnapshot["rating"].toStringAsFixed(2),
        'area':userDocumentSnapshot["area"],
        'date':  selectedDateTime,
        'service':selectedService,
        'status':"Waiting Acceptance"
        
        // Add other fields as needed
      });
      print("test3");

      // Get the ID of the newly created document
      print("??????????????????????????"+newDocRef.id);
      String newDocId = newDocRef.id;

      // Store the ID into another collection
      await FirebaseFirestore.instance.collection('workers').doc(widget.provider_uid).collection("job_offers").doc(newDocId).set({});

  }

  void _showDateTimePicker(BuildContext context) {
    List<String>? workerServices = widget.speciality.cast<String>();
    String? selectedService = workerServices?.first;
    bool isDropDownSelected = false;

    GlobalKey<FormState> dateServiceForm = GlobalKey<FormState>();
    late DateTime? selectedDateTime;

    String? dateTimeValidator(String? val) {
      if (val == null || val.isEmpty) {
        return 'Please select a valid date and time';
      }

      DateTime selectedDate = DateTime.parse(val);
      DateTime currentDate = DateTime.now();
      DateTime minDateTime = currentDate.add(Duration(hours: 48));

      if (selectedDate.isBefore(minDateTime)) {
        return 'Please select a valid date and time';
      }

      return null; // Value is valid
    }
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
            padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: dateServiceForm,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DateTimePicker(
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'd MMM, yyyy',
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      icon: Icon(Icons.event),
                      dateLabelText: 'Date',
                      timeLabelText: "Time",

                      onChanged: (val) => setState(() => selectedDateTime=DateTime.parse(val)),

                      validator: dateTimeValidator,


                    ),
                    SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          items: workerServices
                              ?.map(
                                (String dropDownStringItem) =>
                                DropdownMenuItem<String>(
                                  child: AutoSizeText(dropDownStringItem),
                                  value: dropDownStringItem,
                                ),
                          )
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedService = val ?? '';
                              isDropDownSelected = true;
                            });
                          },
                          value: selectedService,
                          decoration: InputDecoration(
                            labelText: 'Service' ,

                            labelStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,

                            ),

                            prefixIcon: Icon(Icons.handyman),
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
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      width: double.infinity,
                      child: FloatingActionButton(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 3,color: Colors.blue),
                          borderRadius: BorderRadius.circular(25),

                        ),

                backgroundColor: Colors.blue,
                  onPressed: () {
                // Validate the form before proceeding
                if (dateServiceForm.currentState!.validate() &&
                      isDropDownSelected) {
                  dateServiceForm.currentState!.save();
                  print("test1"+selectedDateTime.toString());
                  sendJobOffer(selectedDateTime,selectedService!);

                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(
                            'Your Appointment has been sent successfully, please wait for the Service provider to accept'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);

                            },
                            child:Text(
                              'ok',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                  );

                } else {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(
                            'Please choose a service and ensure that the selected date and time are 48 hours after the current time!'),


                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'ok',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                  );
                }
            },
                        child: AutoSizeText('Send Appointment',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }



  void favorite() {
    setState(() {
      widget.isFavorited = !widget.isFavorited ;
      widget.favoriteColor = widget.isFavorited  ? Colors.red : Colors.grey;

      if (widget.isFavorited ) {
        print("addfavor");
        // Add the spCard to the favorites_spCard list
         addFavorite();
        
       
        // Replace yourSPCardInstance with the actual instance of your SP card.
      } else {
        print("removefavor");
        // Remove the spCard from the favorites_spCard list
        removeFavorite();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    iconcolor();
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
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
              Expanded(
                flex: 2,
                child: Container(
                  child: AutoSizeText(
                    '${widget.provider_name}',
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
              Expanded(
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return spViewProfile(document:widget.document);
                        }),
                      );

                    },
                    icon: Icon(
                      Icons.contact_support_rounded,
                      size: 35,
                    )),
              ),
              Expanded(
                  child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: favorite,
                          icon: Icon(
                            Icons.favorite,
                            color: widget.favoriteColor,
                            size: 35,
                          )))),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.timer),
                  Text(
                    'Status: ',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    '${widget.status}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '${(widget.completed_jobs=="0")? 5:widget.Rating?.toStringAsFixed(2)}',
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
                children: [
                  Icon(Icons.attach_money),
                  Text(
                    "JD's per hour: ${widget.salary}",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.work),
              Text(
                'Jobs completed: ${widget.completed_jobs}',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
          Row(

            children: <Widget>[
              Icon(Icons.handyman),
              Flexible(
                child: Text(
                  'speciality: ${widget.speciality}',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: FloatingActionButton(
                    onPressed: () {
                      if(widget.status != 'Busy')
                      _showDateTimePicker(context);
                    },
                    child: AutoSizeText(
                      'Appointment',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 3, color:(widget.status != 'Busy') ?Colors.green:Colors.grey),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: (widget.status != 'Busy') ?Colors.green:Colors.grey[400],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 9),
                  child: FloatingActionButton(
                    onPressed: () {
                      messageWorker();

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) {
                      //     return ChatPage(Page: "users");
                      //   }),
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ChatDetailScreen(ChatRoomId:"${FirebaseAuth.instance.currentUser?.uid}_${widget.provider_uid}",receiverName:widget.provider_name,receiverUID: widget.provider_uid,receiverImage:widget.document["image_url"]);
                        }),
                      );

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
                      side:
                      BorderSide(width: 3, color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void iconcolor() {
    if(widget.isFavorited)
      widget.favoriteColor=Colors.red;
    else
      widget.favoriteColor= Colors.grey;
  }

}
