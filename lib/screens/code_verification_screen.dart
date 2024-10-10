import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:grad_project/screens/Login_Screen.dart';
import 'package:grad_project/screens/sp_account_creation.dart';
import 'package:grad_project/screens/sp_account_creation_phone.dart';
import 'package:grad_project/screens/sp_app_state_screen.dart';

import 'App_state_screen.dart';
import 'account_creation_screen.dart';
import 'admin_app_state.dart';
import 'admin_home_screen.dart';


class verificationScreen extends StatefulWidget {
  final String Page;
  final String phonenumber;
  verificationScreen({ Key? key, required this.Page, required this.phonenumber}) : super(key: key);
  @override
  State<verificationScreen> createState() => _verificationScreenState();
}

var verificationId;
var smsCode;
class _verificationScreenState extends State<verificationScreen> {
  String  _code="";
  bool _onEditing= false;
  String SubmitButtonText="Submit";


  void verifyOtp(String? code) {


  }


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
        title: Text(
          'Code verification',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[

                  AutoSizeText(
                    'Verification Code',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(height: 40,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                      child: AutoSizeText("Enter your verification code that we sent you through your phone number.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,


                      ),
                        maxLines: 2,
                    ),
                  ),
                  SizedBox(height: 40,),

                  VerificationCode(
                    textStyle: TextStyle(fontSize: 20.0, color: Colors.red[900]),
                    keyboardType: TextInputType.number,
                    underlineColor: Colors.amber,
                    length: 6,
                    cursorColor: Colors.blue,
                    digitsOnly: true,

                    clearAll: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'clear all',
                        style: TextStyle(fontSize: 14.0, decoration: TextDecoration.underline, color: Colors.blue[700]),
                      ),
                    ),
                    onCompleted: (String value) {
                      setState(() {
                        _code = value;
                      });
                    },
                    onEditing: (bool value) {
                      setState(() {
                        _onEditing = value;
                      });
                      if (!_onEditing) FocusScope.of(context).unfocus();
                    },
                  ),


                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                    child: FloatingActionButton(
                      backgroundColor: Colors.blue,
                      onPressed: () async{


                      try{

                        PhoneAuthCredential credential=  (widget.Page=="newWorker")?PhoneAuthProvider.credential(verificationId: SP_creation_phone.verify , smsCode: _code):PhoneAuthProvider.credential(verificationId: Login_Screen.verify , smsCode: _code);

                        if(widget.Page!="new"||widget.Page!="newWorker") {
                          await FirebaseAuth.instance.signInWithCredential(credential);

                        }

                        Navigator.pop(context);

                        if(widget.Page=="new"){
                          SubmitButtonText="Submit& Create Account";
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(
    builder: (context) => AccountCreation(credential:credential,phonenumber:widget.phonenumber)));}
                        if(widget.Page=="users")
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => myAppState(Page:widget.Page,)));

                          if(widget.Page=="workers")
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => mySpAppState(Page:widget.Page)));
                        if(widget.Page=="newWorker") {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      sp_Account_creation(
                                          credential: credential,
                                          phonenumber: widget.phonenumber)));
                        }
                        if(widget.Page=="admin") {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      myAdminAppState()));
                        }

                     } on FirebaseAuthException catch (e) {
    if (e.code == 'invalid-verification-code') {

    showDialog(
    context: context,
    builder: (BuildContext context) {
    return AlertDialog(

    content: Text(
    'The Verification Code You Entered is Incorrect'),
    actions: [
    TextButton(
    onPressed: () {
    // Dismiss the popup and pop the current context
    Navigator.of(context).pop();
    },
    child: Text('OK'),
    ),
    ],


    );
    },);} }

                      catch(e){}
                    }

                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => myAppState()));


                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => mySpAppState()));
                   ,
                      child: const Text(
                        "Submit",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),


                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
