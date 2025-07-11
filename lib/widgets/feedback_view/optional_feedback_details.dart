import 'package:flutter/material.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/feedback_view_model.dart';

class OptionalFeedbackDetails extends StatelessWidget {
  const OptionalFeedbackDetails(
      {super.key,
      required this.sub,
      required this.count,
      required this.list,
      required this.isDark});
  final FeedbackSubject sub;
  final int count;
  final bool isDark;
  final Remark list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sub.staffName)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppController.animatedTitle(sub.fullname, isDark),
              SizedBox(height: 10),
              AppController.heading('Remarks', isDark, Icons.comment),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (var i = 0; i < list.feedrem.length; i++)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 2),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  alignment: Alignment.center,
                                  constraints: BoxConstraints(minWidth: 22),
                                  decoration: BoxDecoration(
                                      color: AppController.darkGreen,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    list.feedrem[i].remark[0].toUpperCase() +
                                        list.feedrem[i].remark
                                            .substring(1)
                                            .toLowerCase(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 0.5,
                            color: Colors.grey.withAlpha(60),
                            margin: EdgeInsets.only(right: 10, left: 30),
                          ),
                        ],
                      ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
