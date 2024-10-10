import 'package:auto_size_text/auto_size_text.dart';
import 'package:grad_project/screens/sp_account_creation_phone.dart';
import 'package:validatorless/validatorless.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'admin_app_state.dart';
import 'code_verification_screen.dart';
import 'account_creation_screen.dart';
import 'package:grad_project/components/FormTextField.dart';
import 'package:grad_project/components/FormTextFieldController.dart';
import 'package:grad_project/screens/sp_account_creation.dart';
import 'package:grad_project/screens/App_state_screen.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({Key? key}) : super(key: key);
  static String verify = "";

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? validatePhone(String? value) {
    return Validatorless.multiple([
      Validatorless.required('The field is obligatory'),
      Validatorless.numbersBetweenInterval(962770000000, 962799999999,
          'this field should contain a valid jordanian phone number'),
    ])(value);
  }

//controllers
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late String Page = "Worker";
  late String reasonOfBan;
  @override
  void dispose() {
    _passwordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void verifyOtp({
    required String verificationId,
    required String userOtp,
  }) async {
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

// could cause errors in case user cancels adding account details part (should add details then sign in)
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user!;

      if (user != null) {
        List<String> userIds = [];
        List<String> workerIds = [];
        var result = await FirebaseFirestore.instance.collection("users").get();
        result.docs.forEach((element) {
          userIds.add(element.reference.id);
        });
        result = await FirebaseFirestore.instance.collection("workers").get();
        result.docs.forEach((element) {
          workerIds.add(element.reference.id);
        });
        if (workerIds.contains(user.uid)) {
          //push worker homepage
        }
        if (userIds.contains(user.uid)) {
          //push user homepage
        }
        if (!userIds.contains(user.uid) && !workerIds.contains(user.uid)) {
          //push sign up
        }

        //if user.uid is not in worker or user db then go to singup page else push relative homepage
      }
    } catch (e) {}
  }

  void signInWithPhone(String phonenumber, String Page) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phonenumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Login_Screen.verify = verificationId;
           // print("helloooo");
            Navigator.push(
                context,
                MaterialPageRoute(
                      builder: (context) => verificationScreen(
                        Page: Page, phonenumber: phonenumber)));
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
     // print(e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
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
                  Container(
                    child: Image.asset('images/splash.png'),
                  ),
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        FormTextFieldController(
                            'Phone Number:',
                            Icon(Icons.phone),
                            _phoneNumberController,
                            true,
                            true,
                            validatePhone),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          child: Flexible(
                            child: AutoSizeText(
                                'Note: Your number should start with 962.'),
                          ),
                        ), //

                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          child: GestureDetector(
                            child: FloatingActionButton(
                              backgroundColor: Colors.blue,
                              onPressed: () async {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => myAdminAppState()));
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  await checkAccount(
                                      _phoneNumberController.text.trim());
                                 // print(Page);
                                  //print("Pagesss");
                                  if (Page == "new" ||
                                      Page == "users" ||
                                      Page == "workers"||
                                      Page == "admin"
                                  )
                                    signInWithPhone(
                                        "+${_phoneNumberController.text.trim()}",
                                        Page);
                                  else if (Page == "banned")
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                              'Your Account has been Banned'),
                                          content: Text(
                                              'Reason of ban: ' + reasonOfBan),
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
                                      },
                                    );
                                  else if (Page == "pending")
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(
                                              'Your Application is being processed'),
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
                                      },
                                    );
                                  else if (Page == "rejected")
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(
                                              'Your Application has been rejected'),
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
                                      },
                                    );


                                 // print('Input value: ');
                                }
                              },
                              child: AutoSizeText(
                                'Continue',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),

                        //create account
                        Container(
                          margin: EdgeInsets.only(top: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: AutoSizeText(
                                  'Want to be a service provider?',
                                  style: TextStyle(
                                    fontSize: 19.0,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return SP_creation_phone();
                                    }),
                                  );
                                },
                                child: Flexible(
                                  child: AutoSizeText(
                                    'Apply now',
                                    style: TextStyle(
                                      color: Colors.blue[800],
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ), //apply now
                      ],
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

  Future<void> checkAccount(String number) async {
    Page = "new";
    if(number=="962771111199"){
      Page="admin";
      return;
    }

    var result = await FirebaseFirestore.instance.collection("users").get();
    result.docs.forEach((document) {
      try {
       // print("phonenumber is????????????????????????????????????");
       // print("+$number");
        if (document["phone_number"] == "+$number") {
          Page = "users";
          if (document["is_banned"] == true) {
            reasonOfBan = document["reason_of_ban"];
            Page = "banned";
          }

          return;
        }
      } catch (e) {}
    });
    if (Page == "new") {
      result = await FirebaseFirestore.instance.collection("workers").get();
      result.docs.forEach((document) {
        try {
          if (document["phone_number"] == "+$number") {
            Page = "workers";
            if (document["is_banned"] == true) {
              reasonOfBan = document["reason_of_ban"];
              Page = "banned";
            }
            if (document["application_status"] == "pending") Page = "pending";
            if (document["application_status"] == "rejected") Page = "rejected";

            return;
          }
        } catch (e) {}
      });
    }
  }
}
