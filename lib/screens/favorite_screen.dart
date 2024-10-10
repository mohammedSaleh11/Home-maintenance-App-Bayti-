import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/sp_card.dart';

class favoritePage extends StatefulWidget {
  @override
  State<favoritePage> createState() => _favoritePageState();
}

class _favoritePageState extends State<favoritePage> {
  List<Map<String, dynamic>?> favWorkerList = [{"_":"_"}];
  List<String> favWorkersId = [];
  bool isLoaded = true;

  void test() {
    print("favWorkerList");
    print(favWorkerList);
  }

  void getFavWorker() async {
    if (isLoaded) {
      isLoaded = false;
      List<Map<String, dynamic>?> templist = [];
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user?.uid;

      var result =
      await FirebaseFirestore.instance.collection("users").doc(uid).collection("favorite_workers").get();

      result.docs.forEach((document) {
        favWorkersId.add(document.reference.id);
      });

      for (int i = 0; i < favWorkersId.length; i++) {
        var result = await FirebaseFirestore.instance.collection("workers").doc(favWorkersId[i]).get().then((value) {
          templist.add(value.data());
        });
      }

      setState(() {
        favWorkerList = templist;
      });

      return null;
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    print("favWorkerList");
    print(favWorkerList);
    getFavWorker();
    test();

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Text(
                  'Favorites',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ), if (favWorkerList.isEmpty) Container(
                height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed

                child: Center(child: AutoSizeText("You don't have any Favorite Workers", style: TextStyle(fontSize: 20),))) // Show CircularProgressIndicator while loading
                else  ListView.builder(
              itemCount: favWorkerList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                 try{
                return spCard(
                  favWorkerList[index]?['first_name'] + " " + favWorkerList[index]?['last_name'],
                  favWorkerList[index]!['job_count'].toString(),
                  favWorkerList[index]!['hourly_rate'].toString(),
                  "Available",
                  favWorkerList[index]?['speciality'],
                  favWorkerList[index]?['rating'].toDouble(),
                  favWorkersId[index],
                  true,
                    favWorkerList[index]!
                );}
                    catch(e){
                  return Center(child: CircularProgressIndicator());
                }
                //spCard(favWorkerList[index]?['first_name']+" "+ favWorkerList[index]?['last_name'],favWorkerList[index]!['job_count'].toString(),favWorkerList[index]!['hourly_rate'].toString(),"Available",favWorkerList[index]?['speciality'].toString(),favWorkerList[index]?['rating'],favWorkersId[index],true);
             },
            ),

          ],
        ),
      ),
    );
  }
}