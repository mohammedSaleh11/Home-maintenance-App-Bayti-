
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/profile_image_utils.dart';
import 'package:grad_project/constants.dart';
import 'package:grad_project/screens/Login_Screen.dart';
import 'package:grad_project/screens/sp_edit_profile_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grad_project/screens/edit_profile_screen.dart';
import 'package:grad_project/components/sp_application.dart';
import 'package:grad_project/components/FormTextField.dart';
import 'package:validatorless/validatorless.dart';
import 'package:grad_project/screens/ban_account_screen.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../components/FormTextFieldController.dart';
import 'home_screen.dart';

class AdminAccountManage extends StatefulWidget {
  @override
  State<AdminAccountManage> createState() => _AdminAccountManageState();
}

class _AdminAccountManageState extends State<AdminAccountManage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String ?phoneNumber;
  String? validate(String? value) {
    return null;

  }



  Future<void> banUser(String uid) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('banUser');
      final HttpsCallableResult result = await callable.call({'uid': uid});
      print('Success: ${result.data}');
    } catch (e) {
      print('Error: $e');
    }
  }
  var UIDController=TextEditingController();
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 60),
                  child: AutoSizeText(
                    'Manage Accounts',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 90,),

                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    children: [

                      FormTextFieldController('Enter Account UID:',Icon(Icons.security),UIDController,true,false,validate),
                      SizedBox(height: 15,),
                      //FormTextField('Telephone',Icon(Icons.phone),validatePhone),
                      Container(
                        width: double.infinity,
                        margin:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: FloatingActionButton(
                          backgroundColor: Colors.blue,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return AccountBan(UIDController.text.trim());

                                }),
                              );
                              // If the form is valid, perform some action
                              _formKey.currentState!.save();
                              // Do something with the input value

                            }




                            //Todo 1
                          },
                          child: AutoSizeText(
                            'Show Details',
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
                      SizedBox(height: 50,),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: FloatingActionButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              backgroundColor: Colors.red,
                              child: Text(
                                'Sign Out',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Text('Are you sure you want to sign out?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          FirebaseAuth.instance.signOut();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  Login_Screen()));
                                        },
                                        child: Text('Yes',style: TextStyle(fontSize: 20),),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);

                                        },
                                        child: Text('No',style: TextStyle(fontSize: 20),),
                                      ),
                                    ],
                                  ),
                                );



                              }
                          ),
                        ),
                      ),

                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
   }

}
