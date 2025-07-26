import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/feedback_list_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/shimmer/feedback_shimmer.dart';

class FeedbackListScreen extends ConsumerWidget {
  const FeedbackListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    Size size = MediaQuery.of(context).size;

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
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
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
                              FeebackEnabler(
                                isDark: isDark,
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
                                    onPressed: () async {},
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

class FeebackEnabler extends StatefulWidget {
  const FeebackEnabler(
      {super.key,
      required this.isDark,
      required this.value,
      required this.ques});
  final bool value;
  final bool isDark;
  final String ques;

  @override
  State<FeebackEnabler> createState() => _FeebackEnablerState();
}

class _FeebackEnablerState extends State<FeebackEnabler> {
  bool enable = false;

  @override
  void initState() {
    enable = widget.value;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          enable = !enable;
        });
      },
      child: Row(
        children: [
          Checkbox(
            value: enable,
            activeColor: widget.isDark
                ? AppController.lightGreen
                : AppController.darkGreen,
            onChanged: (val) {
              enable = val!;
              setState(() {});
            },
          ),
          Expanded(
            child: Text(
              widget.ques,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
