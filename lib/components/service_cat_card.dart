
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class serviceCard extends StatelessWidget {
  String serviceText;
  IconData serviceIcon;
  Color serviceIconColor;
  serviceCard(this.serviceIcon,this.serviceText,this.serviceIconColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
         color: Colors.teal[100],
        border: Border.all(
          color: Colors.black,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Icon(serviceIcon,size: 70,color: serviceIconColor,),
          SizedBox(height: 20,),
          AutoSizeText(serviceText,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),maxLines: 1,),
      ],
      ),
    );
  }
}
