import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/feedback_view_model.dart';
import 'package:senthil/widgets/feedback_view/optional_feedback_details.dart';

class OptionalFeedback extends StatelessWidget {
  const OptionalFeedback({super.key, required this.isDark, required this.snap});
  final FeedbackViewModel snap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var i = 0; i < snap.data.feedbackSubjects.length; i++)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppController.lightBlue,
                  child: Text(
                    snap.data.feedbackSubjects[i].fullname[0].toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
                title: Text(
                  '${i + 1}. ${snap.data.feedbackSubjects[i].fullname}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  snap.data.feedbackSubjects[i].staffName,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                trailing: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppController.red)),
                  child: Text(
                    '${snap.data.feedbackTab2.feedRemCounts[i]}',
                    style: TextStyle(
                        color: AppController.red, fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () {
                  Get.to(
                      () => OptionalFeedbackDetails(
                          sub: snap.data.feedbackSubjects[i],
                          isDark: isDark,
                          count: snap.data.feedbackTab2.feedRemCounts[i],
                          list: snap.data.feedbackTab2.remarks[i]),
                      transition: Transition.rightToLeft);
                },
              ),
              Container(
                height: 1,
                margin: EdgeInsets.only(right: 10, left: 60),
                color: Colors.grey.withAlpha(100),
              )
            ],
          )
      ],
    );
  }
}
