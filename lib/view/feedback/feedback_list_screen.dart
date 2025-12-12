import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/feedback_list_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/feedback_items_model.dart';
import 'package:senthil/shimmer/feedback_shimmer.dart';
import 'package:senthil/view/feedback/feedback_setting_screen.dart';
import 'package:senthil/widgets/feedback/feedback_enabler.dart';
import 'package:senthil/widgets/my_chip.dart';
import 'package:senthil/widgets/no_record_content.dart';

class FeedbackListScreen extends ConsumerStatefulWidget {
  const FeedbackListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FeedbackListScreenState();
}

class _FeedbackListScreenState extends ConsumerState<ConsumerStatefulWidget> {
  Widget radioButton(bool v, String value, bool isE) {
    return RadioListTile(
      value: v,
      groupValue: isE,
      onChanged: (val) {
        ref.read(FeedbackListController.isEnabled.notifier).state = val!;
      },
      title: Text(value),
    );
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    await ref.read(feedbackListProvider.notifier).loadItems();
    ref.read(FeedbackListController.isLoading.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    bool isLoading = ref.watch(FeedbackListController.isLoading);
    bool isEnabled = ref.watch(FeedbackListController.isEnabled);
    List<FeedbackItem> snap = ref.watch(feedbackListProvider);
    final size = MediaQuery.of(context).size;
    final selectedType = ref.watch(FeedbackListController.selectedType);

    var pad = size.width > 500
        ? size.width > 800
            ? size.width > 1000
                ? size.width * 0.20
                : size.width * 0.16
            : size.width * 0.12
        : 2.0;

    Widget listCard(FeedbackItem feedback) => Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          color: isDark ? Colors.grey.withAlpha(100) : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FeedbackEnabler(
                isDark: isDark,
                id: feedback.id,
                value: feedback.show == 1,
                ques: '${feedback.ord}. ${feedback.subject}',
              ),
              Row(
                children: [
                  SizedBox(width: 5),
                  MyChip(feedback.board, AppController.headColor),
                  SizedBox(width: 5),
                  MyChip('${feedback.questype} type', AppController.lightBlue),
                  SizedBox(width: 5),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      FeedbackListController.openEditSheet(context, feedback);
                    },
                    color: AppController.yellow,
                    icon: Icon(TablerIcons.edit),
                  ),
                ],
              ),
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => FeedbackSettingScreen(),
                  transition: Transition.rightToLeft);
            },
            icon: Icon(TablerIcons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: pad),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              if (size.width > 500)
                BoxShadow(
                  offset: Offset(0, 0.5),
                  color: Colors.grey.withAlpha(100),
                  spreadRadius: 1,
                  blurRadius: 2,
                ),
            ],
          ),
          child: isLoading
              ? FeedbackShimmer(isDark: isDark)
              : snap.isEmpty
                  ? NoRecordContent(msg: 'There is not feedbacks!')
                  : Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: radioButton(true, 'Enable', isEnabled)),
                            Expanded(
                                child:
                                    radioButton(false, 'Disable', isEnabled)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: selectedType,
                                  isDense: true,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  hint: Text('choose..'),
                                  items: ['All', 'Common', 'Staff']
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ))
                                      .toList(),
                                  onChanged: (v) {
                                    ref
                                        .read(FeedbackListController
                                            .selectedType.notifier)
                                        .state = v!;
                                  },
                                ),
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: FilledButton(
                                  onPressed: () {
                                    ref
                                        .read(feedbackListProvider.notifier)
                                        .updateShow(selectedType, ref);
                                  },
                                  child: Text('Update'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'Questions',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 5),
                              for (var feedback in snap.where((e) {
                                if (selectedType == 'All') return true;
                                return e.questype.toLowerCase() ==
                                    selectedType.toLowerCase();
                              }).toList())
                                listCard(feedback),
                              SizedBox(height: 80),
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FeedbackListController.openEditSheet(context, null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
