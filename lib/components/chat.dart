import 'package:flutter/material.dart';
import 'package:grad_project/screens/chat_detail_screen.dart';

class ChatUsersList extends StatefulWidget {
  String receiverName;
  String receiverUID;
  String image;
  String ChatRoomId;
  int NewMessage=0;
  ChatUsersList(this.receiverName,this.receiverUID, this.image,this.ChatRoomId,this.NewMessage);

  @override
  State<ChatUsersList> createState() => _chatUsersListState();
}

class _chatUsersListState extends State<ChatUsersList> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ChatDetailScreen(ChatRoomId:widget.ChatRoomId,receiverName:widget.receiverName,receiverUID: widget.receiverUID,receiverImage: widget.image);
        }),
      ); },
      child: Container(
        padding: EdgeInsets.only (left:16,right:16,top:10,bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(

                    radius: 30,
                    backgroundImage: widget.image != ""
                        ? NetworkImage(widget.image)
                        : NetworkImage('https://icons.iconarchive.com/icons/papirus-team/papirus-status/512/avatar-default-icon.png'),),

                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.receiverName),
                          SizedBox(
                            height: 6,
                          ),
                          (widget.NewMessage!=0)?
                          Text(
                            'New message',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          )
                          :Container(),

                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
