import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/subject_details_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/subject_details_model.dart';

class SubjectDetailsEdit extends ConsumerStatefulWidget {
  const SubjectDetailsEdit({super.key, this.info});
  final SubjectInfo? info;

  @override
  ConsumerState<SubjectDetailsEdit> createState() => _SubjectDetailsEditState();
}

class _SubjectDetailsEditState extends ConsumerState<SubjectDetailsEdit> {
  final fullName = TextEditingController();
  final shortName = TextEditingController();
  final groupName = TextEditingController();
  final cbseOrder = TextEditingController();
  final matricOrder = TextEditingController();

  @override
  void initState() {
    if (widget.info != null) {
      fullName.text = widget.info!.fullname;
      shortName.text = widget.info!.shortname!;
      groupName.text = widget.info!.subgroup!;
      cbseOrder.text = '${widget.info!.ord}';
      matricOrder.text = '${widget.info!.mOrd}';
    }
    super.initState();
  }

  @override
  void dispose() {
    fullName.dispose();
    shortName.dispose();
    groupName.dispose();
    cbseOrder.dispose();
    matricOrder.dispose();
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
          AppController.heading(
              widget.info != null ? 'Edit Subject' : 'Add Subject',
              isDark,
              widget.info != null ? TablerIcons.edit : Icons.add),
          SizedBox(height: 10),
          TextField(
            controller: fullName,
            decoration: InputDecoration(labelText: 'Full Name'),
          ),
          SizedBox(height: 10),
          TextField(
            controller: shortName,
            decoration: InputDecoration(labelText: 'Short Name'),
          ),
          SizedBox(height: 10),
          TextField(
            controller: groupName,
            decoration: InputDecoration(labelText: 'Subject Group'),
          ),
          SizedBox(height: 10),
          TextField(
            controller: cbseOrder,
            decoration: InputDecoration(labelText: 'CBSE Order'),
          ),
          SizedBox(height: 10),
          TextField(
            controller: matricOrder,
            decoration: InputDecoration(labelText: 'Matric Order'),
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
                    ref.read(subjectDetailsProvider.notifier).addOrEdit(
                      {
                        if (widget.info != null) 'id': widget.info!.id,
                        'subjectfull': fullName.text,
                        'subjectshort': shortName.text,
                        'subjectgroup': groupName.text,
                        'subjectcbse': cbseOrder.text,
                        'subjectmatric': matricOrder.text,
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
