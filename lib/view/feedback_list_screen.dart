import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/feedback_list_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/shimmer/feedback_shimmer.dart';
import 'package:senthil/widgets/feedback/feedback_enabler.dart';

class FeedbackListScreen extends ConsumerStatefulWidget {
  const FeedbackListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FeedbackListScreenState();
}

class _FeedbackListScreenState extends ConsumerState<ConsumerStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;

    Widget myChip(String value, Color color) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          value,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Feedback')),
      body: SafeArea(
          child: ref.watch(FeedbackListController.loadItems).when(
                data: (snap) {
                  if (snap.data.isEmpty) {
                    return SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.filter_list_off, size: 30),
                          SizedBox(height: 10),
                          Text('Feedback List Empty!'),
                        ],
                      ),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      for (var feedback in snap.data)
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          color: isDark
                              ? Colors.grey.withAlpha(100)
                              : Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FeedbackEnabler(
                                isDark: isDark,
                                id: feedback.id,
                                value: feedback.show == 1,
                                ques:
                                    '${snap.data.indexOf(feedback) + 1}. ${feedback.subject}',
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  myChip(
                                      feedback.board, AppController.headColor),
                                  SizedBox(width: 5),
                                  myChip('${feedback.questype} type',
                                      AppController.lightBlue),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () =>
                                        FeedbackListController.openEditSheet(
                                            context, feedback, (q) {
                                      snap.data[snap.data.indexOf(feedback)] =
                                          q;
                                      setState(() {});
                                    }),
                                    color: AppController.yellow,
                                    icon: Icon(TablerIcons.edit),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
                error: (error, _) => SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 30),
                      SizedBox(height: 10),
                      Text('Something went wrong!'),
                    ],
                  ),
                ),
                loading: () => FeedbackShimmer(isDark: isDark),
              )),
    );
  }
}
