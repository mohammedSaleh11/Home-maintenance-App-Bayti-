import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/FormTextField.dart';
import 'package:grad_project/components/FormTextFieldController.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:open_file/open_file.dart';
import 'package:grad_project/models/CustomIcons.dart';
import 'package:validatorless/validatorless.dart';
import 'package:grad_project/screens/Login_Screen.dart';

import '../auth/main_page.dart';


class sp_Account_creation extends StatefulWidget {
  final PhoneAuthCredential credential;
  final String phonenumber;

  sp_Account_creation({ Key? key, required this.credential, required this.phonenumber}) : super(key: key);
  @override
  State<sp_Account_creation> createState() => _spAccountCreationState();
}

class _spAccountCreationState extends State<sp_Account_creation> {
  String? gender;
  List<ValueItem> selectedspeciality = [];
  String? selectedCurrency;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isMultiDropdownValid = false;
  bool isGenderValid = false;
  bool isDropDownValid=false;
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



  final _firstNameController=TextEditingController();
  final _lastNameController=TextEditingController();
  final _emailController=TextEditingController();
  final _hourlyController=TextEditingController();
  final _genderController=TextEditingController();
  final _cityController=TextEditingController();
  final _areaController=TextEditingController();
  final _descriptionController=TextEditingController();
  final _linkController=TextEditingController();


  @override
  void dispose(){
    _hourlyController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _genderController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _emailController.dispose();
    _linkController.dispose();
    _descriptionController;
super.dispose(); }


    Future addUserDetails() async{
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user?.uid;
      print("uid");
      print(uid);
      List<String?> arrayofSpecialities = selectedspeciality.map((item) => item.value).toList();
      await FirebaseFirestore.instance.collection('workers').doc(uid).set({
        "image_url":"",

        'phone_number':widget.phonenumber,

        'email':_emailController.text.trim(),

        'first_name':_firstNameController.text.trim(),

        'last_name':_lastNameController.text.trim(),

        'gender':_genderController.text.trim(),

        'area':_areaController.text.trim(),

        'city':_cityController.text.trim(),

        "hourly_rate":int.parse(_hourlyController.text.trim()),

        "link":_linkController.text.trim(),

        "description":_descriptionController.text.trim(),

        'job_count':0,

        'rating':0,

        "speciality":arrayofSpecialities,

        "status": "Available",

        "is_banned":false,

        "reason_of_ban":"",

        "application_status":"pending"




      });
      await FirebaseFirestore.instance.collection('workerApplications').doc(uid).set({
        "image_url":"",

        'phone_number':widget.phonenumber,

        'email':_emailController.text.trim(),

        'first_name':_firstNameController.text.trim(),

        'last_name':_lastNameController.text.trim(),

        'gender':_genderController.text.trim(),

        'area':_areaController.text.trim(),

        'city':_cityController.text.trim(),

        "hourly_rate":_hourlyController.text.trim(),

        "link":_linkController.text.trim(),

        "description":_descriptionController.text.trim(),

        'job_count':0,

        'rating':0,

        "speciality":arrayofSpecialities,

        "status": "Available",

        "is_banned":false,

        "reason_of_ban":"",

        "application_status":"pending"




      });}

    Future signUp() async{


      await FirebaseAuth.instance.signInWithCredential(widget.credential);

      addUserDetails();
    }

    void viewFile(PlatformFile file) {
      OpenFile.open(file.path);
    }




    String? validatelink(String? value) {

    }
  String? validate(String? value) {
    return Validatorless.multiple([
      Validatorless.required('The field is obligatory')
    ])(value);
  }


  String? validateSalray(String? value) {
    return Validatorless.multiple([
      Validatorless.required('The field is obligatory'),
      Validatorless.number('please enter a valid salary'),

    ])(value);
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
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 35,
                      ),
                      AutoSizeText(
                        'Service Provider Application',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 35,
                      ),



                      FormTextFieldController('First Name:',Icon(Icons.person),_firstNameController,true,false,validate),
                      SizedBox(
                        height: 20,
                      ),
                      FormTextFieldController('Last Name:',Icon(Icons.person),_lastNameController,true,false,validate),
                      SizedBox(
                        height: 20,
                      ),
                      FormTextFieldController('Email(optional):',Icon(Icons.email),_emailController,true,false,validatelink),
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
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
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
                                    gender = value.toString();
                                    isGenderValid=true;
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
                                  gender = value.toString();
                                  isGenderValid=true;
                                });
                              },

                            ),
                          ],
                        ),
                      ), //Gender
                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(),
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          child: MultiSelectDropDown(

                            hint: 'specialit(ies):',
                            hintStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                            borderColor: Colors.black,
                            borderRadius: 25,
                            borderWidth: 3,



                            onOptionSelected:(List<ValueItem> selectedOptions) {
                              setState(() {
                                selectedspeciality = selectedOptions;
                                isMultiDropdownValid = selectedOptions.isNotEmpty;

                              });
                            },
                            options: <ValueItem>[
                              ValueItem(label: 'Electrician', value: 'electrical'),
                              ValueItem(label: 'Plumber', value: 'plumbing'),
                              ValueItem(label: 'Carpenter', value: 'carpentry'),
                              ValueItem(label: 'HVAC Technician', value: 'hvac services'),
                              ValueItem(label: 'Painter', value: 'painting'),
                              ValueItem(label: 'Satellite Technician', value: 'satellite television'),
                            ],

                            selectionType: SelectionType.multi,




                            dropdownHeight: 300,
                            optionTextStyle: const TextStyle(fontSize: 16),
                            selectedOptionIcon: const Icon(Icons.check_circle),
                          ),
                        ),
                      ), //specialties
                      SizedBox(
                        height: 20,
                      ),

                      FormTextFieldController('Salary per hour:',Icon(Icons.monetization_on),_hourlyController,true,true,validate),
                      SizedBox(
                        height: 20,
                      ),
                      FormTextFieldController('link for your work(optional):',Icon(Icons.link),_linkController,true,false,validatelink),


                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          controller: _descriptionController,
                          validator: validate,
                          decoration: InputDecoration(
                            labelText: 'Tell Us About Yourself:',
                            labelStyle: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),

                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 3.0,
                              ),
                            ),
                          ),
                        ),
                      ), //tell us about yourself

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
                            if (_formKey.currentState!.validate() &&
                                isMultiDropdownValid &&
                                isGenderValid) {
                              if(gender==null)
                              gender='male';
                              _cityController.text= SelectedCity!;
                              _genderController.text=gender!;
                              signUp();
                              _formKey.currentState!.save();

                              FirebaseAuth.instance.signOut();
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  Login_Screen()));
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(

                                    content: Text('Your Application has been submitted and is being processed'),
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

                              // Do something with the input value
                            }
                            else{
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Text('please fill in all the required fields!'),
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
                            'Apply',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ), //apply button
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Already have an Account?',
                            style: TextStyle(
                              fontSize: 19.0,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                  color: Colors.blue[800],
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                          ),
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

 

