import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/content_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/content_model.dart';

class ContentEdit extends ConsumerStatefulWidget {
  const ContentEdit({super.key, this.info});

  final SchoolData? info;
  @override
  ConsumerState<ContentEdit> createState() => _ExamDetailsEditState();
}

class _ExamDetailsEditState extends ConsumerState<ContentEdit> {
  final name = TextEditingController(),
      order = TextEditingController(),
      refId = TextEditingController();
  int selectedType = 1;
  List<String> myList = ['Common', 'CBSE', 'Matric'];

  @override
  void initState() {
    if (widget.info != null) {
      name.text = widget.info!.name;
      order.text = '${widget.info!.ord}';
      refId.text = '${widget.info!.id}';
      selectedType = widget.info!.ctype;
    }
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    order.dispose();
    refId.dispose();
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
              widget.info != null ? 'Edit Content' : 'Add New Content',
              isDark,
              widget.info != null ? TablerIcons.edit : Icons.add),
          SizedBox(height: 10),
          TextField(
            controller: name,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          SizedBox(height: 10),
          TextField(
            controller: order,
            decoration: InputDecoration(labelText: 'Order'),
          ),
          SizedBox(height: 10),
          TextField(
            controller: refId,
            decoration: InputDecoration(labelText: 'Ref Id'),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Text('➡ Content Type')),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<int>(
                  value: selectedType,
                  items: myList
                      .map<DropdownMenuItem<int>>(
                        (e) => DropdownMenuItem(
                          value: myList.indexOf(e) + 1,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    selectedType = val!;
                  },
                ),
              ),
            ],
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
                    ref.read(contentProvider.notifier).addOrEdit(
                      {
                        'content': name.text,
                        'order': order.text,
                        'ref': refId.text,
                        'type': selectedType,
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
