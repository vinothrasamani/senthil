import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/feedback_items_model.dart';

class EditFeedback extends ConsumerStatefulWidget {
  const EditFeedback(
      {super.key, required this.feedback, required this.onUpdate});
  final FeedbackItem? feedback;
  final Function(FeedbackItem f) onUpdate;

  @override
  ConsumerState<EditFeedback> createState() => _EditFeedbackState();
}

class _EditFeedbackState extends ConsumerState<EditFeedback> {
  TextEditingController controller = TextEditingController();
  String? qType, board;
  bool isLoading = false;

  Widget drop(String q, List<String> list, String hint, String? val,
      Function(String?)? onChanged) {
    return Row(
      children: [
        Expanded(child: Text(q)),
        SizedBox(width: 8),
        SizedBox(
          width: 160,
          child: DropdownButton(
            items: list
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            hint: Text(hint),
            underline: Container(height: 0.5, color: Colors.grey),
            value: val,
            isExpanded: true,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    if (widget.feedback != null) {
      controller.text = widget.feedback!.subject;
      qType = widget.feedback!.questype;
      board = widget.feedback!.board;
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.feedback != null ? 'Edit Feedback' : 'Add New',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: isDark ? AppController.lightBlue : baseColor),
          ),
          SizedBox(height: 10),
          Text('1. Subject'),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Question',
            ),
            minLines: 1,
            maxLines: 2,
          ),
          SizedBox(height: 15),
          drop('2. Question Type', ['Common', 'Staff'], 'Type', qType, (v) {
            qType = v;
            setState(() {});
          }),
          drop('3. Board', ['CBSE', 'Matric'], 'Board', board, (v) {
            board = v;
            setState(() {});
          }),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Cancel')),
              ),
              SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          if (widget.feedback != null) {
                            final str =
                                await AppController.send('feedback-edit', {
                              'id': widget.feedback!.id,
                              'sub': controller.text,
                              'type': qType,
                              'board': board,
                            });
                            final data = feedbackItemsModelFromJson(str);
                            if (data.success) {
                              widget.onUpdate(data.data[0]);
                            }
                          } else {
                            final str =
                                await AppController.send('feedback-add', {
                              'sub': controller.text,
                              'type': qType,
                              'board': board,
                            });
                            print(str);
                          }
                          setState(() {
                            isLoading = false;
                          });
                          Get.back();
                        },
                  child: Text(widget.feedback != null ? 'Update' : 'Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
