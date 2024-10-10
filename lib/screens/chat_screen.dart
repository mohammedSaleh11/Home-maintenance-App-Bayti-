
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/chat.dart';
import 'package:grad_project/models/chat_users.dart';

class ChatPage extends StatefulWidget {
  final String Page;
  ChatPage({ Key? key, required this.Page}) : super(key: key);



  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String,dynamic>?> chatRoomsList = [];
  List<String> chatRoomsIDs = [];
  bool isLoaded=true;

  void getFavWorker() async{
    print("wael");
    print("hello"+isLoaded.toString());
    if(isLoaded) {
      isLoaded=false;
      print("hello"+isLoaded.toString());
      List<Map<String, dynamic>?> templist = [];
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user?.uid;
      print(widget.Page);
      print("uid");

      print(uid);
      var result = await FirebaseFirestore.instance.collection(widget.Page).doc(
          uid).collection("chat_rooms").get();

      result.docs.forEach((document) {
        chatRoomsIDs.add(document.reference.id);
      });
      if(chatRoomsIDs.isEmpty)
        chatRoomsIDs=["000","000"];
      print("chatRoomsIDsis"+chatRoomsIDs.toString());
      setState(() {
        chatRoomsIDs=chatRoomsIDs;
      });

      // for (int i = 0; i < chatRoomsIDs.length; i++) {
      //   var result = await FirebaseFirestore.instance.collection("chatRooms")
      //       .doc(chatRoomsIDs[i]).get()
      //       .then((value) {
      //     templist.add(value.data());
      //   });
      //   String chatCardId;
      //   if(widget.Page=="workers") {
      //     chatCardId = chatRoomsIDs[i].substring(0,chatRoomsIDs[i].indexOf('_'));
      //
      //   } else {
      //     chatCardId = chatRoomsIDs[i].substring(chatRoomsIDs[i].indexOf('_')+1,chatRoomsIDs[i].length);
      //   }
      //   print("wael"+chatCardId);
      //   if(widget.Page=="users"){
      //    result = await FirebaseFirestore.instance.collection("workers").doc(chatCardId).get().
      //    then((value) {
      //      templist[i]?["name"]=value["first_name"]+" "+value["last_name"];
      //    //NOTE: ALSO ADD REF TO IMAGE
      //
      //    }); }
      //   else{
      //     print(chatCardId);
      //     result = await FirebaseFirestore.instance.collection("users").doc(chatCardId).get().
      //     then((value) {
      //       templist[i]?["name"]=value["first_name"]+" "+value["last_name"];
      //       //NOTE: ALSO ADD REF TO IMAGE
      //
      //     });
      //   }
      //
      // }


      print(chatRoomsIDs);
      return null;
    }
    else
      return null;

  }




  @override
  Widget build(BuildContext context) {
    print("chatRoomsIDs");
    getFavWorker();

    print("chatRoomsIDs");
    print(chatRoomsIDs);
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
                child: Padding(
                  padding:  EdgeInsets.only(left: 16,right: 16,top: 10),
                  child: Text(
                    'Chats',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                )
            ),


            StreamBuilder<QuerySnapshot>(

//chatRoomsIDs.contains(FirebaseFirestore.instance.collection("chatRooms").doc().id) .orderBy("worker_lastActive",descending:false)
              //stream:FirebaseFirestore.instance.collection('chatRooms').doc("yMUmRWl2lbXez88DHIgExMUoLI72_workertest").collection("messages").orderBy("time",descending:false).snapshots(),
              stream:chatRoomsIDs.isNotEmpty
                  ?
              FirebaseFirestore.instance.collection('chatRooms').where(FieldPath.documentId, whereIn:chatRoomsIDs ).snapshots():null,
              builder: (context, snapshot) {
               // try {

                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.hasError||!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  String chatCardStatus="";
                  print("test1");
                  if(widget.Page=="users")
                    chatCardStatus="newMessageFromWorker_timestamp";
                  else
                    chatCardStatus="newMessageFromUser_timestamp";
                  print("test2");
                  var sortedDocuments = snapshot.data!.docs;

                  sortedDocuments.sort((a, b) {
                    print("(a[chatCardStatus] as Timestamp).toDate().millisecondsSinceEpoch");


                    var aData =(a[chatCardStatus]==0)? 0: (a[chatCardStatus] as Timestamp).toDate().millisecondsSinceEpoch;
                    var bData = (b[chatCardStatus]==0)? 0: (b[chatCardStatus] as Timestamp).toDate().millisecondsSinceEpoch ;
                    print("heloooooooooooo"+sortedDocuments.toString());

                    for (var chatCard in sortedDocuments) {
                      print(chatCard["worker_name"]);

                    }
                    return bData.compareTo(aData);
                  });
                  print(sortedDocuments.toString());
                  for (var chatCard in sortedDocuments) {
                    print(chatCard["worker_name"]);

                  }
                  //var sortedDocuments = snapshot.data!.docs.sort((a, b) => a.data()?['worker_lastActive'].compareTo(b.data()?['worker_lastActive']));

                  final chatCards = sortedDocuments;
                  List<Widget> chatWidgets = [];

                  for (var chatCard in chatCards) {

                    late String cardName;
                    if(widget.Page=="users")
                      cardName="worker_name";
                    else
                      cardName="user_name";
                    print("plssssssssssssssss");
                    print(chatCard["user_image_url"]);
                    final chatcardWidget=  ChatUsersList(
                        chatCard[cardName],
                        (widget.Page=="workers")?chatCard.id.substring(0,chatCard.id.indexOf('_')):
                        chatCard.id.substring(chatCard.id.indexOf('_')+1,chatCard.id.length),
                        (widget.Page=="users")?
                        chatCard["worker_image_url"]:
                        chatCard["user_image_url"],
                        chatCard.reference.id,
                        (widget.Page=="users")?
                        (chatCard["newMessageFromWorker_timestamp"] ==0)?0:(chatCard["newMessageFromWorker_timestamp"] as Timestamp).toDate().millisecondsSinceEpoch:
                        (chatCard["newMessageFromUser_timestamp"] ==0)?0:(chatCard["newMessageFromUser_timestamp"] as Timestamp).toDate().millisecondsSinceEpoch



                    );
                    chatWidgets.add(chatcardWidget);
                  }


                  return (chatWidgets.isNotEmpty) ?

                  ListView.builder(
                    itemCount: chatWidgets.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return chatWidgets[index];
                    },
                  ) : Container(
                    height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed

                    child: Center(child: AutoSizeText("You Don't have any Chats",
                      style: TextStyle(fontSize: 20),)),
                  );
                //}
               // catch(e){return Center(child: CircularProgressIndicator(),);}
                // return ListView(
                //   children: chatWidgets,
                // );
              },
            ),


            //
            // ListView.builder(
            //   itemCount: chatRoomsList.length,
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   itemBuilder: (context,index){
            //     return ChatUsersList(
            //       chatRoomsList[index]?["name"],
            //         "cool",
            //         chatUsers[1].image,
            //         " ",
            //       chatRoomsIDs[index],
            //
            //
            //     );
            //   },
            // )

          ],
        ),
      ),
    );
  }
}
