import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/components/job_card.dart';
import 'package:grad_project/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
class AccountBan extends StatefulWidget {
  String UID;

  AccountBan(
      this.UID,
      );

  @override
  State<AccountBan> createState() => _AccountBanState();
}
late DocumentSnapshot tempdocumentSnapshot;
class _AccountBanState extends State<AccountBan> {
late  DocumentSnapshot? documentSnapshot =null;
  late String account_type;
bool isloaded = false;

  getAccountDetails(String uid) async{
if(isloaded == false) {
  print("test1");

  await FirebaseFirestore.instance.collection("users").doc(widget.UID)
      .get()
      .then((value) {
    tempdocumentSnapshot = value;
  });
  print("test1");
  print(tempdocumentSnapshot.exists);
  if (tempdocumentSnapshot.exists)
    setState(() {
      account_type = "User";
      documentSnapshot = tempdocumentSnapshot;

      isloaded = true;
    });
  else {
    await FirebaseFirestore.instance.collection("workers").doc(widget.UID)
        .get()
        .then((value) {
      tempdocumentSnapshot = value;
    });
    setState(() {
      account_type = "Worker";
      documentSnapshot = tempdocumentSnapshot;
      isloaded = true;
    });
  }
}
print("account_type");
 print(widget.UID);
  }

var reasonController=TextEditingController();
  void showRateModal(BuildContext context) {


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:

          (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  'Ban Reason',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: reasonController,
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: null,
                  decoration: InputDecoration(
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
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 3, color: Colors.red),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  onPressed: () async {
                    String collection="users";
                    if(account_type=="Worker")
                      collection="workers";
await FirebaseFirestore.instance.collection(collection).doc(widget.UID).update({
  "is_banned":true,
  "reason_of_ban":reasonController.text.trim()


});

                    Navigator.pop(context);
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              'The Account has been banned'),
                          content: Text(
                                widget.UID+"  Has been Succesfully Banned"),
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
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {


      getAccountDetails(widget.UID);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white,),
          ),
          title: Text(
            'User Information',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        body:  Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black,
                  width: 4,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AutoSizeText.rich(
                    TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'First Name:  ',
                          style: profilelabelStyle,
                        ),
                        TextSpan(
                          text: '${documentSnapshot?["first_name"]}',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        // Add more TextSpan widgets as needed
                      ],
                    ),
                    maxLines: 1, // Adjust the number of lines as needed
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  AutoSizeText.rich(
                    TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Last Name:  ',
                          style: profilelabelStyle,
                        ),
                        TextSpan(
                          text: ' ${documentSnapshot?["last_name"]}',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        // Add more TextSpan widgets as needed
                      ],
                    ),
                    maxLines: 1, // Adjust the number of lines as needed
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  AutoSizeText.rich(
                    TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Email:  ',
                          style: profilelabelStyle,
                        ),
                        TextSpan(
                          text: ' ${documentSnapshot?["email"]}',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        // Add more TextSpan widgets as needed
                      ],
                    ),
                    maxLines: 1, // Adjust the number of lines as needed
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  AutoSizeText.rich(
                    TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Phone Number:  ',
                          style: profilelabelStyle,
                        ),
                        TextSpan(
                          text: ' ${documentSnapshot?["phone_number"]}',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        // Add more TextSpan widgets as needed
                      ],
                    ),
                    maxLines: 1, // Adjust the number of lines as needed
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  AutoSizeText.rich(
                    TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Gender:  ',
                          style: profilelabelStyle,
                        ),
                        TextSpan(
                          text: ' ${documentSnapshot?["gender"]}',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        // Add more TextSpan widgets as needed
                      ],
                    ),
                    maxLines: 1, // Adjust the number of lines as needed
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  AutoSizeText.rich(
                    TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'City:  ',
                          style: profilelabelStyle,
                        ),
                        TextSpan(
                          text: ' ${documentSnapshot?["city"]}',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        // Add more TextSpan widgets as needed
                      ],
                    ),
                    maxLines: 1, // Adjust the number of lines as needed
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  AutoSizeText.rich(
                    TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Area:  ',
                          style: profilelabelStyle,
                        ),
                        TextSpan(
                          text: ' ${documentSnapshot?["area"]}',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        // Add more TextSpan widgets as needed
                      ],
                    ),
                    maxLines: 1, // Adjust the number of lines as needed
                  ),


                  SizedBox(
                    height: 30,
                  ),
                  AutoSizeText.rich(
                    TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Rating:  ',
                          style: profilelabelStyle,
                        ),
                        TextSpan(
                          text: ' ${documentSnapshot?["rating"].toStringAsFixed(
                              2)}',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        // Add more TextSpan widgets as needed
                      ],
                    ),
                    maxLines: 1, // Adjust the number of lines as needed
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  AutoSizeText.rich(
                    TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Job Count:  ',
                          style: profilelabelStyle,
                        ),
                        TextSpan(
                          text: ' ${documentSnapshot?["job_count"]}',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        // Add more TextSpan widgets as needed
                      ],
                    ),
                    maxLines: 1, // Adjust the number of lines as needed
                  ),


                  SizedBox(
                    height: 30,
                  ),
                  (account_type == "Worker") ? AutoSizeText.rich(
                    TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Salary:  ',
                          style: profilelabelStyle,
                        ),
                        TextSpan(
                          text: ' ${documentSnapshot?["hourly_rate"]}',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        // Add more TextSpan widgets as needed
                      ],
                    ),
                    maxLines: 1, // Adjust the number of lines as needed
                  ) : SizedBox(height: 0),


                  (account_type == "Worker") ? SizedBox(
                    height: 30,
                  ) : SizedBox(height: 0),

                  (account_type == "Worker") ? AutoSizeText.rich(
                    TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Status:',
                          style: profilelabelStyle,
                        ),
                        TextSpan(
                          text: ' ${documentSnapshot?["status"]}',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        // Add more TextSpan widgets as needed
                      ],
                    ),
                    maxLines: 1, // Adjust the number of lines as needed
                  ) : SizedBox(height: 0),


                  (account_type == "Worker") ? SizedBox(
                    height: 30,
                  ) : SizedBox(height: 0),

                  (account_type == "Worker") ? AutoSizeText.rich(
                    TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Specialty(ies):  ',
                          style: profilelabelStyle,
                        ),
                        TextSpan(
                          text: ' ${documentSnapshot?["speciality"].toString()}',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        // Add more TextSpan widgets as needed
                      ],
                    ),
                    maxLines: 2, // Adjust the number of lines as needed
                  ) : SizedBox(height: 0),


                  (account_type == "Worker") ? SizedBox(
                    height: 30,
                  ) : SizedBox(height: 0),


                  AutoSizeText.rich(
                    TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Account Type : ',
                          style: profilelabelStyle,
                        ),
                        TextSpan(
                          text: ' $account_type',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        // Add more TextSpan widgets as needed
                      ],
                    ),
                    maxLines: 1, // Adjust the number of lines as needed
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  AutoSizeText.rich(
                    TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Account UID:',
                          style: profilelabelStyle,
                        ),
                        TextSpan(
                          text: ' ${widget.UID}',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        // Add more TextSpan widgets as needed
                      ],
                    ),
                    maxLines: 2, // Adjust the number of lines as needed
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  (documentSnapshot?["is_banned"]) ?
                  AutoSizeText.rich(
                    TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'why banned: ',
                          style: profilelabelStyle,
                        ),
                        TextSpan(
                          text: ' ${documentSnapshot?["reason_of_ban"]}',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 17,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        // Add more TextSpan widgets as needed
                      ],
                    ),
                    maxLines: 10, // Adjust the number of lines as needed
                  ) : Container(),

                  SizedBox(
                    height: 30,
                  ),


                  (!documentSnapshot?["is_banned"]) ?
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 9),
                    child: FloatingActionButton(
                      onPressed: () {
                        showRateModal(context);
                      },
                      child: AutoSizeText(
                        'Ban',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        side:
                        BorderSide(width: 3, color: Colors.red),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  )

                      : Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 9),
                    child: FloatingActionButton(
                      onPressed: () async {
                        String collection="users";
                        if(account_type=="Worker")
                          collection="workers";
                        await FirebaseFirestore.instance.collection(collection).doc(widget.UID).update({
                          "is_banned":false,
                        });

                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'The Account has been Unbanned'),
                              content: Text(
                                  widget.UID+"  Has been Succesfully Unbanned"),
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


                      },
                      child: AutoSizeText(
                        'unBan',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        side:
                        BorderSide(width: 3, color: Colors.red),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: Colors.red,
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


