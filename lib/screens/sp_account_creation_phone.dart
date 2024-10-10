import 'package:auto_size_text/auto_size_text.dart';
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

class SP_creation_phone extends StatefulWidget {


  const SP_creation_phone({Key? key}):super(key:key);
  static String verify="";







  @override
  State<SP_creation_phone> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<SP_creation_phone> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? validatePhone(String? value) {
    return Validatorless.multiple([
      Validatorless.required('The field is obligatory'),
      Validatorless.numbersBetweenInterval(962770000000, 962799999999, 'this field should contain a valid jordanian phone number'),

    ])(value);
  }

//controllers
  final _emailController= TextEditingController();
  final _passwordController= TextEditingController();
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  late String Page="Worker";
  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void verifyOtp({
    required String verificationId,
    required String userOtp,
  }) async{

    try{


      PhoneAuthCredential creds=PhoneAuthProvider.credential(verificationId: verificationId, smsCode: userOtp);

// could cause errors in case user cancels adding account details part (should add details then sign in)
      User? user= (await _firebaseAuth.signInWithCredential(creds)).user!;

      if(user !=null){
        List<String> userIds = [];
        List<String> workerIds = [];
        var result =await FirebaseFirestore.instance.collection("users").get();
        result.docs.forEach((element) {userIds.add(element.reference.id); });
        result =await FirebaseFirestore.instance.collection("workers").get();
        result.docs.forEach((element) {workerIds.add(element.reference.id); });
        if(workerIds.contains(user.uid)){
          //push worker homepage

        }
        if(userIds.contains(user.uid)){
          //push user homepage

        }
        if(!userIds.contains(user.uid) && !workerIds.contains(user.uid)){
          //push sign up

        }


        //if user.uid is not in worker or user db then go to singup page else push relative homepage

      }
    }
    catch(e){}

  }

  void signInWithPhone(String phonenumber,String Page) async{

    try{
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phonenumber,
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential )async{
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);

          },
          verificationFailed: (error){
            throw Exception(error.message);

          },
          codeSent: (verificationId,forceResendingToken){

            SP_creation_phone.verify=verificationId;
              print("Page");
            print(Page);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  verificationScreen(Page: Page,phonenumber:phonenumber)));



          },
          codeAutoRetrievalTimeout:(String verificationId){});

    } on FirebaseAuthException catch(e){
      print(e.message.toString());


    }


  }

  Future signIn() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
        title: AutoSizeText(
          'Service Provider Account Creation',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,

          ),
          maxLines: 1,
        ),

      ),
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
                  width: double.infinity,

                  margin: EdgeInsets.symmetric(horizontal: 30,vertical: 40),
                  child: AutoSizeText('Please enter you phone number to continue with your application process!',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                ),
                  Form(
                    autovalidateMode:AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        FormTextFieldController('Phone Number:',Icon(Icons.phone),_emailController,true,true,validatePhone),
                        SizedBox(height: 5,),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          child: AutoSizeText('Note: Your number should start with 962.'),), //


                        Container(
                          width: double.infinity,
                          margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                                  await checkPhone(_emailController.text.trim());
                                  if(Page=="newWorker")
                                  signInWithPhone("+${_emailController.text.trim()}",Page);
                                  else

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(

                                          content: Text('The Number you Entered is Linked to Another Account'),
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


                                  print('Input value: ');
                                }

                              },
                              child: AutoSizeText(
                                'Continue',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white
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
                        //apply now
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
  Future<void> checkPhone(String number) async {
    Page = "newWorker";
    var result = await FirebaseFirestore.instance.collection("users").get();
    result.docs.forEach((document) {
      print("phonenumber is????????????????????????????????????");
      print("+$number");
      if (document["phone_number"] == "+$number") {
        Page = "old";

        return;
      }
    });
    if (Page == "newWorker") {
      result = await FirebaseFirestore.instance.collection("workers").get();
      result.docs.forEach((document) {
        if (document["phone_number"] == "+$number") {
          Page = "old";

          return;
        }
      });

    }
  }


}
