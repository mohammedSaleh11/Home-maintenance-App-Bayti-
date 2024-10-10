import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/chat_detail_screen_Appbar.dart';
import 'package:grad_project/components/chat_bubble.dart';
import 'package:grad_project/models/chat_message.dart';
import 'package:grad_project/models/user_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
enum MessageType {
  sender,
  receiver,
}

class ChatDetailScreen extends StatefulWidget {

  final String ChatRoomId;
  final String receiverName;
  final String receiverUID;
  final String receiverImage;
  const ChatDetailScreen({Key? key,required this.ChatRoomId, required this.receiverName,required this.receiverUID, required String this.receiverImage}) :super(key:key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen>
    with WidgetsBindingObserver {
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  late String googleMapsLink;
  late String accountType;




  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  void showModal() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return InkWell(
            onTap: () {
              sendLocation();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              height: 80,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 50,
                  ),
                  Icon(
                    Icons.location_on,
                    size: 34,
                    color: Colors.lightBlue,
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'Location',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  late String messageText;

  void sendLocation() async {
    try {
      var uid=auth.currentUser?.uid;




      final userLocation = Location();
      await userLocation.getCurrentLocation();
      googleMapsLink =  await userLocation.getGoogleMapsLink();
      print("googel link"+googleMapsLink);
      int message_timestamp;


      await FirebaseFirestore.instance.collection('chatRooms').doc(widget.ChatRoomId).collection("messages").add({
        'text': googleMapsLink,
        'sender': uid,
        'time':FieldValue.serverTimestamp(),
        // Add more fields like sender information if needed
      });



    } catch (e) {
      print(e);
      // Handle the exception
      return null;
    }




    setState(() {
     // chatMessage.add(ChatMessage('${googleMapsLink}', MessageType.sender));
    });
    scrollToEnd();
  }
  void sendMessage() async {

    var uid=auth.currentUser?.uid;
    int message_timestamp;

    messageText = _messageController.text.trim();
    print("FieldValue.serverTimestamp() as int");
    print(FieldValue.serverTimestamp());
    if (messageText.isNotEmpty) {
      await FirebaseFirestore.instance.collection('chatRooms').doc(widget.ChatRoomId).collection("messages").add({
        'text': messageText,
        'sender': uid,
        'time': FieldValue.serverTimestamp(),
        // Add more fields like sender information if needed
      });


      if(widget.ChatRoomId.substring(0,widget.ChatRoomId.indexOf('_'))==uid){
        print("heeeeeeeeeeeeeeee");
        FirebaseFirestore.instance.collection('chatRooms').doc(widget.ChatRoomId).update(
            {"newMessageFromUser_timestamp":FieldValue.serverTimestamp()});}
      else {
        FirebaseFirestore.instance.collection('chatRooms').doc(widget.ChatRoomId).update(
            {"newMessageFromWorker_timestamp":FieldValue.serverTimestamp()});
      }




    }
  }




  SendPushNotification() async {



    DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('workers')
        .doc(widget.receiverUID)
        .get();
    String receiverDB;
    String senderDB;
    (querySnapshot.exists)? receiverDB="workers":receiverDB="users";
    (querySnapshot.exists)? senderDB="users":senderDB="workers";

    DocumentSnapshot doc= await FirebaseFirestore.instance
        .collection(senderDB)
        .doc(auth.currentUser?.uid)
        .get();


    // // await FirebaseFirestore.instance
    // //     .collection(receiverDB)
    // //     .doc(widget.receiverUID).collection("notifications").add({
    // //     'senderUid': auth.currentUser?.uid,
    // //     'senderType': (querySnapshot.exists)?"user":"worker",
    // // 'receiverUid': widget.receiverUID,
    // // 'receiverType': (querySnapshot.exists)?"worker":"user",
    // // 'text': doc["first_name"]+" "+doc["last_name"]+"Has Sent You a New Message:"+_messageController.text.trim(),
    // // 'timestamp':DateTime.now()
    // // }
    //
    // );


  await FirebaseFirestore.instance.collection('notifications').add({
  'senderUid': auth.currentUser?.uid,
    'senderType': (querySnapshot.exists)?"user":"worker",
  'recipientFCMToken': "do9ZrJT5RgS-iLdnfNeIiO:APA91bHj43p2gEG_vShO61RIJCypPBzQaUmgkOkZgInyF6X8QVm4KVFXn8GE_gfPylZDWNrdr-ihja3571O4dLhcxj_JQVIocu3AG53lIk63oeweZtM4TfHbQSyeLVPzbTGfLN4Kl0iL",
    'recipientType': (querySnapshot.exists)?"worker":"user",
  'text': doc["first_name"]+" "+doc["last_name"]+" Has Sent You a New Message:"+ messageText,
  });
print("test5");

  }

  void scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  Future<bool> checkUidInWorkerCollection(String? uid) async {
    try {
      DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(uid)
          .get();

      return querySnapshot.exists;
    } catch (e) {
      // Handle errors if any
      print("Error checking uid in worker collection: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),

      resizeToAvoidBottomInset: true,
      appBar: ChatDetailScreenAppBar(username:widget.receiverName,image: widget.receiverImage),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: <Widget>[
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: chatMessage.length,
            //     controller: _scrollController,
            //     shrinkWrap: true,
            //     padding: EdgeInsets.only(top: 10, bottom: 10),
            //     physics: BouncingScrollPhysics(),
            //     itemBuilder: (context, index) {
            //       return ChatBubble(
            //         chatMessage[index],
            //       );
            //     },
            //   ),
            // ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(

                stream: FirebaseFirestore.instance.collection('chatRooms').doc(widget.ChatRoomId).collection("messages").orderBy("time",descending:false).snapshots(),
                builder: (context, snapshot) {


                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final messages = snapshot.data!.docs.reversed;
                  List<Widget> messageWidgets = [];
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final User? user = auth.currentUser;
                  final uid = user?.uid;
                  if(widget.ChatRoomId.substring(0,widget.ChatRoomId.indexOf('_'))==uid)
                    FirebaseFirestore.instance.collection('chatRooms').doc(widget.ChatRoomId).update(
                        {"newMessageFromWorker_timestamp":0});
                    else
                    FirebaseFirestore.instance.collection('chatRooms').doc(widget.ChatRoomId).update(
                        {"newMessageFromUser_timestamp":0});
                  for (var message in messages) {
                    final messageText = message['text'];
                    final messageWidget;
                    if(message['sender']==uid){
                    messageWidget = ChatBubble(messageText,"sender");}
                    else  messageWidget = ChatBubble(messageText,"receiver");

                    messageWidgets.add(messageWidget);
                  }
                  return ListView(
                    controller: _scrollController,

                    reverse: true,
                    children: messageWidgets,
                  );
                },
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 16, bottom: 10),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showModal();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 21),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type message...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 13, left: 12),
                    margin: EdgeInsets.only(right: 30, bottom: 14),
                    child: FloatingActionButton(
                      backgroundColor: Colors.blue,
                      onPressed: ()  {
                         SendPushNotification();
                         sendMessage();


                        _messageController.clear();
                        setState(() {

                          scrollToEnd();

                        });
                      },
                      child: Icon(Icons.send, color: Colors.white),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    Future.delayed(Duration(milliseconds: 300), () {
      scrollToEnd();
    });
  }
}
