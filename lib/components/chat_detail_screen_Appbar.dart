import 'package:flutter/material.dart';
import 'package:grad_project/components/sp_card.dart';

class ChatDetailScreenAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String username;
  final String image;
  const ChatDetailScreenAppBar( {Key? key,required this.username,required this.image}) :super(key:key);
   
  @override
  Widget build(BuildContext context) {
    return AppBar(

      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Colors.black), // Change the color to black
              ),
              SizedBox(width: 12),
              CircleAvatar(
                radius: 25,
                backgroundImage: image != ""
                    ? NetworkImage(image)
                    : NetworkImage('https://icons.iconarchive.com/icons/papirus-team/papirus-status/512/avatar-default-icon.png'),),






              SizedBox(width: 7,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      username,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56); // Use a suitable height, for example, 56.
}

