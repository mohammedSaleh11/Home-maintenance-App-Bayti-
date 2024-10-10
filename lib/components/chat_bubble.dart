import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:grad_project/models/chat_message.dart';
import 'package:grad_project/screens/chat_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
class ChatBubble extends StatefulWidget {
  String chatMessage;
  String type;
  ChatBubble(this.chatMessage,this.type);

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}
Uri _url=Uri.parse("");
class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
      child: Align(
        alignment: (widget.type == "receiver"?Alignment.topLeft:Alignment.topRight),
        child: Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: (widget.type == "receiver"?Colors.white:Colors.lightBlue[100]),

          ),
          padding: EdgeInsets.all(16),
          child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: (widget.chatMessage.length >= 8 && widget.chatMessage.substring(0, 8) == "https://")?
                  GestureDetector(
                    onTap: () {
                       _url = Uri.parse(widget.chatMessage);
                      launchGoogleMapsLink(_url);
                    }
                    ,
                    child: Text(
                      widget.chatMessage,
                      maxLines: null,
                      style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  ):
                  Text(widget.chatMessage,maxLines: null,style: TextStyle(fontSize: 16),))),
        ),
      ),
    );
  }
  void launchGoogleMapsLink(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}




