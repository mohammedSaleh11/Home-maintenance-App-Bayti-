import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/FormTextField.dart';
import 'package:grad_project/components/FormTextFieldController.dart';
import 'package:grad_project/screens/App_state_screen.dart';
import 'package:validatorless/validatorless.dart';

import '../auth/main_page.dart';

class AccountCreation extends StatefulWidget {
  final PhoneAuthCredential credential;
  final String phonenumber;
  AccountCreation({ Key? key, required this.credential, required this.phonenumber}) : super(key: key);


  @override
  State<AccountCreation> createState() => _AccountCreationState();
}

class _AccountCreationState extends State<AccountCreation> {
final _emailController=TextEditingController();
final _firstNameController=TextEditingController();
final _lastNameController=TextEditingController();
final _phoneController=TextEditingController();
final _genderController=TextEditingController();
final _cityController=TextEditingController();
final _areaController=TextEditingController();
final _streetnameController=TextEditingController();

GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool isGenderValid=false;
bool isDropDownValid=false;
String? validate(String? value) {
  return Validatorless.multiple([       Validatorless.required('The field is obligatory')     ])
    (value);   }
String? validateEmail(String? value) {     return Validatorless.multiple([       Validatorless.email('The field should contain a valid email')     ])(value);   }


@override
void dispose(){
  _areaController.dispose();
  _streetnameController.dispose();
  _emailController.dispose();
  _firstNameController.dispose();
   _lastNameController.dispose();
  _phoneController.dispose();
  _genderController.dispose();
  _cityController.dispose();
  super.dispose();
}

Future signUp() async{


await FirebaseAuth.instance.signInWithCredential(widget.credential);

addUserDetails();
}

Future addUserDetails() async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = user?.uid;
await FirebaseFirestore.instance.collection('users').doc(uid).set({
"image_url":"",
  'phone_number':widget.phonenumber,

  'email':_emailController.text.trim(),

  'first_name':_firstNameController.text.trim(),

  'last_name':_lastNameController.text.trim(),

  'gender':_genderController.text.trim(),

  'city':_cityController.text.trim(),

  'area':_areaController.text.trim(),

  'job_count':0,

  'rating':0,

  "is_banned":false,

  "reason_of_ban":"",



});


}


  List<String> cities = [
    'Amman',
    'Irbid',
    'Zarqa',
    'Aqaba',
    'Salt',
    'Jarash',
    'karak',
    'Madaba',
  ];
  String? SelectedCity = 'Amman';

  String? gender;
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
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 35,
                      ),
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      FormTextFieldController('First Name:', Icon(Icons.person),_firstNameController,true,false,validate),
                      SizedBox(
                        height: 20,
                      ),
                      FormTextFieldController('Last Name:', Icon(Icons.person),_lastNameController,true,false,validate),
                      SizedBox(
                        height: 20,
                      ),
                      FormTextFieldController('Email(optional):', Icon(Icons.email),_emailController,true,false,validateEmail),
                      SizedBox(
                        height: 20,
                      ),
                      FormTextFieldController('Area:', Icon(Icons.location_pin),_areaController,true,false,validate),
                      SizedBox(
                        height: 20,
                      ),



                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: DropdownButtonFormField<String>(
                          items: cities.map(
                                (String DropDownStringItem) {
                              return DropdownMenuItem<String>(
                                child: Text(DropDownStringItem),
                                value: DropDownStringItem,
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            setState(() {

                              SelectedCity = val as String;
                              isDropDownValid=true;
                            });
                          },
                          value: SelectedCity,


                          decoration: InputDecoration(
                            labelText: 'City',
                            labelStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIcon: Icon(Icons.location_city,),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 3.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Gender:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Male',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                child: Radio(
                                  value: "male",
                                  groupValue: gender,
                                  onChanged: (value) {
                                    setState(() {
                                      isGenderValid=true;
                                      gender = value.toString();
                                    });
                                  },
                                ),
                              ),
                              Text(
                                'Female',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Radio(
                                value: "female",
                                groupValue: gender,
                                onChanged: (value) {

                                  setState(() {
                                    isGenderValid=true;
                                    gender = value.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        width: double.infinity,
                        margin:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: FloatingActionButton(
                          backgroundColor: Colors.blue,
                          onPressed: () {
                            print("test");
                            print("test");
                            print("test");

                            if (_formKey.currentState!.validate() && isGenderValid) {

                              // If the form is valid, perform some action
                              _formKey.currentState!.save();
                               if(gender==null);
                               gender='male';
                              _genderController.text=gender!;
                              _cityController.text= SelectedCity!;


                              signUp();
                              Navigator.pushReplacement(
                                  context,
                              MaterialPageRoute(
                                  builder: (context) => myAppState(Page:"users")));

                            }
                            else{
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Text('please fill in all the fields with valid infromation'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('ok',style: TextStyle(fontSize: 20),),
                                    ),

                                  ],
                                ),
                              );
                            }

                            //Todo 1
                          },
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
