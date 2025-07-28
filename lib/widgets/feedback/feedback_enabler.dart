import 'package:flutter/material.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/feedback_list_controller.dart';

class FeedbackEnabler extends StatefulWidget {
  const FeedbackEnabler(
      {super.key,
      required this.isDark,
      required this.value,
      required this.id,
      required this.ques});
  final bool value;
  final int id;
  final bool isDark;
  final String ques;

  @override
  State<FeedbackEnabler> createState() => _FeebackEnablerState();
}

class _FeebackEnablerState extends State<FeedbackEnabler> {
  bool enable = false, updating = false;

  @override
  void initState() {
    enable = widget.value;
    setState(() {});
    super.initState();
  }

  void toggle() async {
    setState(() {
      updating = true;
    });
    final res = await FeedbackListController.updateFeedback(widget.id);
    if (res) {
      enable = !enable;
    }
    setState(() {
      updating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: Row(
        children: [
          updating
              ? Container(
                  margin: EdgeInsets.all(10),
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Checkbox(
                  value: enable,
                  activeColor: widget.isDark
                      ? AppController.lightGreen
                      : AppController.darkGreen,
                  onChanged: (val) async {
                    toggle();
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
