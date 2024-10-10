import 'package:flutter/material.dart';
class FormTextFieldController extends StatelessWidget {

  String labelText='';
  var controller;
  var icon_choice;
  bool visibilty=true;
  bool numberOnly=false;
  var keyboardTypeValue;
  final String? Function(String?) validateFunction;
  String _inputValue = '';
  FormTextFieldController(this.labelText,this.icon_choice,this.controller,this.visibilty,this.numberOnly,this.validateFunction);

 void keyboardtype(){
   if(numberOnly)
     keyboardTypeValue=TextInputType.phone;
 else
     keyboardTypeValue=TextInputType.text;
 }

  @override
  Widget build(BuildContext context) {
       keyboardtype();
    return   Container(
      margin: EdgeInsets.symmetric(horizontal: 30),

      child: TextFormField(
        validator: validateFunction,
        onSaved:(value) { _inputValue = value!;         },
        keyboardType: keyboardTypeValue,
        obscureText: !visibilty,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          prefixIcon: icon_choice,
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
    );
  }
}
