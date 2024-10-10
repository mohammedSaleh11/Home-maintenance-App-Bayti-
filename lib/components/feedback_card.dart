import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:grad_project/constants.dart';

class FeedbackContainer extends StatelessWidget {
  String jobId;
   String userFeedBack;
   String workerFeedBack;
   String userRating;
   String workerRating;
   String userName;
   String workerName;
   String serviceDateTime;
   String serviceType;
   String location;
   String userUid;
   String workerUid;


  FeedbackContainer(
      this.jobId,
     this.userFeedBack,
     this.workerFeedBack,
      this.userRating,
      this.workerRating,
     this.userName,
     this.workerName,
     this.serviceDateTime,
     this.serviceType,
     this.location,
  this.userUid,
      this.workerUid,
  );

  @override
  Widget build(BuildContext context) {
    print("jobId");
    print(jobId);
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            AutoSizeText.rich(
              TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'JobId:  ',
                    style: profilelabelStyle,
                  ),
                  TextSpan(
                    text: ' $jobId',
                    style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17,),
                  ),
                  // Add more TextSpan widgets as needed
                ],
              ),
              maxLines: 1, // Adjust the number of lines as needed
            ),
            SizedBox(height: 8),
            AutoSizeText.rich(
              TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Location:  ',
                    style: profilelabelStyle,
                  ),
                  TextSpan(
                    text: ' $location',
                    style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17,),
                  ),
                  // Add more TextSpan widgets as needed
                ],
              ),
              maxLines: 1, // Adjust the number of lines as needed
            ),
            SizedBox(height: 8),
            AutoSizeText.rich(
              TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Date:  ',
                    style: profilelabelStyle,
                  ),
                  TextSpan(
                    text: ' $serviceDateTime',
                    style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17,),
                  ),
                  // Add more TextSpan widgets as needed
                ],
              ),
              maxLines: 2, // Adjust the number of lines as needed
            ),
            SizedBox(height: 8),
            AutoSizeText.rich(
              TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Service:  ',
                    style: profilelabelStyle,
                  ),
                  TextSpan(
                    text: ' $serviceType',
                    style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17,),
                  ),
                  // Add more TextSpan widgets as needed
                ],
              ),
              maxLines: 1, // Adjust the number of lines as needed
            ),
            SizedBox(height: 8),
            AutoSizeText.rich(
              TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'User UID:  ',
                    style: profilelabelStyle,
                  ),
                  TextSpan(
                    text: ' $userUid',
                    style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                  ),

                  // Add more TextSpan widgets as needed
                ],
              ),
              maxLines: 1, // Adjust the number of lines as needed
            ),
            SizedBox(height: 8),
            AutoSizeText.rich(
              TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'User Name:  ',
                    style: profilelabelStyle,
                  ),
                  TextSpan(
                    text: ' $userName',
                    style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                  ),

                  // Add more TextSpan widgets as needed
                ],
              ),
              maxLines: 1, // Adjust the number of lines as needed
            ),
            SizedBox(height: 8),
            AutoSizeText.rich(
              TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'User Feedback:  ',
                    style: profilelabelStyle,
                  ),
                  TextSpan(
                    text: ' $userFeedBack',
                    style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                  ),

                  // Add more TextSpan widgets as needed
                ],
              ),
              maxLines: 1, // Adjust the number of lines as needed
            ),
            SizedBox(height: 8),
            AutoSizeText.rich(
              TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'User Rating:  ',
                    style: profilelabelStyle,
                  ),
                  TextSpan(
                    text: ' $userRating',
                    style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                  ),

                  // Add more TextSpan widgets as needed
                ],
              ),
              maxLines: 1, // Adjust the number of lines as needed
            ),
            SizedBox(height: 8),
            AutoSizeText.rich(
              TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Worker UID:  ',
                    style: profilelabelStyle,
                  ),
                  TextSpan(
                    text: ' $workerUid',
                    style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                  ),

                  // Add more TextSpan widgets as needed
                ],
              ),
              maxLines: 1, // Adjust the number of lines as needed
            ),
            SizedBox(height: 8),
            AutoSizeText.rich(
              TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Worker Name:  ',
                    style: profilelabelStyle,
                  ),
                  TextSpan(
                    text: ' $workerName',
                    style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                  ),

                  // Add more TextSpan widgets as needed
                ],
              ),
              maxLines: 1, // Adjust the number of lines as needed
            ),
            SizedBox(height: 8),
            AutoSizeText.rich(
              TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Worker Feedback:  ',
                    style: profilelabelStyle,
                  ),
                  TextSpan(
                    text: ' $workerFeedBack',
                    style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                  ),

                  // Add more TextSpan widgets as needed
                ],
              ),
              maxLines: 1, // Adjust the number of lines as needed
            ),
            SizedBox(height: 8),
            AutoSizeText.rich(
              TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Worker Rating:  ',
                    style: profilelabelStyle,
                  ),
                  TextSpan(
                    text: ' $workerRating',
                    style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17),
                  ),

                  // Add more TextSpan widgets as needed
                ],
              ),
              maxLines: 1, // Adjust the number of lines as needed
            ),


            SizedBox(height: 5.0),








          ],
        ),
      ),
    );
  }
}
