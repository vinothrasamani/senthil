import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/exam_details_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/exam_details_model.dart';

class ExamDetailsEdit extends ConsumerStatefulWidget {
  const ExamDetailsEdit({super.key, this.info});

  final Examinfo? info;
  @override
  ConsumerState<ExamDetailsEdit> createState() => _ExamDetailsEditState();
}

class _ExamDetailsEditState extends ConsumerState<ExamDetailsEdit> {
  final name = TextEditingController(), order = TextEditingController();

  @override
  void initState() {
    if (widget.info != null) {
      name.text = widget.info!.examName ?? 'None';
      order.text = '${widget.info!.ord ?? 0}';
    }
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    order.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppController.heading(widget.info != null ? 'Edit Exam' : 'Add Exam',
              isDark, widget.info != null ? TablerIcons.edit : Icons.add),
          SizedBox(height: 10),
          TextField(
            controller: name,
            decoration: InputDecoration(labelText: 'Exam Name'),
          ),
          SizedBox(height: 10),
          TextField(
            controller: order,
            decoration: InputDecoration(labelText: 'Exam Order'),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    ref.read(examDetailsProvider.notifier).addOrEdit(
                      {
                        'exam': name.text,
                        'order': order.text,
                        if (widget.info != null) 'id': widget.info!.id,
                      },
                      widget.info == null,
                    );
                  },
                  child: Text(widget.info != null ? 'Edit' : 'Add'),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          )
        ],
      ),
    );
  }
}
