import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/sp_card.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';


class searchScreen extends StatefulWidget {
  final String serviceCato;

  const searchScreen({Key? key,required this.serviceCato}) :super(key:key);

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  List<String> SortBy = [
    'Rating',
    'status',
    "JD's per hour",
    'jobs completed',
  ];


  List<Map<String,dynamic>?> WorkerList = [{"":""}];
  List<String> WorkersId = [];
  List<String> favWorkersId = [];
  List<bool>  favCurrentUser = [];
  bool isLoaded=true;

  Future getWorkers() async{
    if(isLoaded){
      isLoaded=false;
    List<Map<String,dynamic>?> templist = [];


    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;




      var result = await FirebaseFirestore.instance.collection("users").doc(
          uid).collection("favorite_workers").get();

      result.docs.forEach((document) {
        favWorkersId.add(document.reference.id);
      });
print(widget.serviceCato);

     result =await FirebaseFirestore.instance.collection("workers").where('speciality',arrayContains:widget.serviceCato).where("status",isEqualTo:"Available").where("is_banned",isEqualTo:false).where("application_status",isEqualTo:"accepted")
        .get();
      print(result.docs.length);
    result.docs.forEach((document) {

      WorkersId.add(document.reference.id );


    });
    for(int i =0;i<WorkersId.length;i++){

      await FirebaseFirestore.instance.collection("workers").doc(WorkersId[i]).get().then((value) {

         var temp=value.data();

         temp?["id"]=WorkersId[i];
        templist.add(temp);
       print(templist.toString());



      });


    }//Random().nextDouble() * 300

      templist.sort((a, b) {

       var weightA = a?["rating"] * 240 + a?["job_count"] * 0.4 + Random().nextDouble() * 300;
       var weightB = b?["rating"] * 240 + b?["job_count"]  * 0.4 + Random().nextDouble() * 300;


        return weightB.compareTo(weightA);
      });



    setState(() {
      WorkerList= templist;
    });
    return null;}
    else
      return null;
  }



  List<ValueItem> selectedSpecialities = [];
  List <ValueItem> selectedSortBy=[] ;

  @override
  Widget build(BuildContext context) {
    getWorkers();
    print(WorkerList.toString());
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
        title: AutoSizeText(
          'Search for Service Providers',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          maxLines: 1,
        ),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: [

                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: EdgeInsets.symmetric(vertical: 15,horizontal: 10),


                    ),
                  ),






                ],
              ), (WorkerList.isNotEmpty)?
              ListView.builder(
                itemCount: WorkerList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  try {
                    return spCard(
                        WorkerList[index]?['first_name'] + " " +
                            WorkerList[index]?['last_name'],
                        WorkerList[index]!['job_count'].toString(),
                        WorkerList[index]!['hourly_rate'].toString(),
                        WorkerList[index]?['status'],
                        WorkerList[index]?['speciality'],
                        WorkerList[index]?['rating'].toDouble(),
                        WorkerList[index]?['id'],
                        favWorkersId.contains(WorkersId[index].toString()),
                        WorkerList[index]!

                    );
                   }
                   catch(e){return Center(child: CircularProgressIndicator(),);}
                },
              ):Container(
                  height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed

                  child: Center(child: AutoSizeText("There are no Available Workers",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold), ))),
            ],
          ),
        ),
      ),
    );
  }
}
