import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/feedback_list_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/feedback_items_model.dart';

class EditFeedback extends ConsumerStatefulWidget {
  const EditFeedback({super.key, required this.feedback});
  final FeedbackItem? feedback;

  @override
  ConsumerState<EditFeedback> createState() => _EditFeedbackState();
}

class _EditFeedbackState extends ConsumerState<EditFeedback> {
  TextEditingController controller = TextEditingController();
  TextEditingController order = TextEditingController();
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
          child: DropdownButtonFormField(
            items: list
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            hint: Text(hint),
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
      order.text = widget.feedback!.ord.toString();
    }
    super.initState();
  }

  void submit() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (widget.feedback != null) {
        final str = await AppController.send('feedback-edit', {
          'id': widget.feedback!.id,
          'subject': controller.text,
          'type': qType,
          'order': order.text,
          'board': board,
        });
        final data = feedbackItemsModelFromJson(str);
        if (data.success) {
          ref.read(feedbackListProvider.notifier).editFeedback(data.data[0]);
        }
      } else {
        final str1 = await AppController.send('new-feedback-save', {
          'subject': controller.text,
          'type': qType,
          'order': order.text,
          'board': board,
        });
        final data1 = feedbackItemsModelFromJson(str1);
        if (data1.success) {
          ref.read(feedbackListProvider.notifier).addNew(data1.data[0]);
        }
      }
    } catch (e) {
      isLoading = false;
    }
    setState(() {
      isLoading = false;
    });
    Get.back();
  }

  @override
  void dispose() {
    controller.dispose();
    order.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.feedback != null ? 'Edit Feedback' : 'Add New Feedback',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppController.lightBlue : baseColor),
            ),
            SizedBox(height: 10),
            Text('1. Subject'),
            SizedBox(height: 5),
            TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Question',
                ),
                minLines: 1,
                maxLines: 2),
            SizedBox(height: 15),
            drop('2. Question Type', ['Common', 'Staff'], 'Type', qType, (v) {
              qType = v;
              setState(() {});
            }),
            SizedBox(height: 8),
            drop('3. Board', ['CBSE', 'Matric'], 'Board', board, (v) {
              board = v;
              setState(() {});
            }),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text('4. Question Order')),
                SizedBox(height: 5),
                SizedBox(
                  width: 160,
                  child: TextFormField(
                      controller: order,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Order')),
                ),
              ],
            ),
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
                    onPressed: isLoading ? null : submit,
                    child: Text(widget.feedback != null ? 'Update' : 'Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
