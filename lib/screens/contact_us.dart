import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class contactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          'Contact Us',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
        Expanded(
          child: Container(
          child: Image.asset('images/splash.png'),
      ),
        ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40,vertical: 50),
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(1),
                      spreadRadius: 5,
                      blurRadius: 9,
                      offset: Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Scrollbar(

                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(

                            children: <Widget>[
                              Icon(Icons.phone,color: Colors.lightBlue,),
                              SizedBox(width: 15,),
                              Flexible(child: AutoSizeText('0795039713',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            children: <Widget>[
                              Icon(Icons.email,color: Colors.lightBlue,),
                              SizedBox(width: 15,),
                              Flexible(child: Text('mohSalehWork@gmail.com',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            children: <Widget>[
                              Icon(Icons.location_on,color: Colors.lightBlue,),
                              SizedBox(width: 15,),
                              Flexible(child: Text('Amman-Jordan',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                            ],
                          ),


                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
