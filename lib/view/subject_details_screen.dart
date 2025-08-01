import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/subject_details_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/subject_details_model.dart';
import 'package:senthil/shimmer/list_shimmer.dart';
import 'package:senthil/widgets/my_chip.dart';

class SubjectDetailsScreen extends ConsumerWidget {
  const SubjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listener = ref.watch(subjectDetailsProvider);
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: Text('Subject Details')),
      body: SafeArea(
        child: listener.when(
          data: (snap) => ListView(
            padding: EdgeInsets.only(bottom: 80, left: 10, right: 10, top: 10),
            children: [
              for (var item in snap) myCard(context, item, isDark),
            ],
          ),
          error: (error, _) {
            return Center(
              child: Text('Something went wrong!'),
            );
          },
          loading: () => ListShimmer(isDark: isDark),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SubjectDetailsController.openEditor(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget myCard(BuildContext context, SubjectInfo item, bool isDark) =>
      Container(
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withAlpha(100), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MyCheck(
                  isDark: isDark,
                  value: item.show == 1,
                  id: item.id,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.fullname,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 6),
                MyChip('📗 ${item.shortname}', AppController.lightBlue),
                SizedBox(width: 4),
                IconButton(
                  onPressed: () {
                    SubjectDetailsController.openEditor(context, item);
                  },
                  color: AppController.yellow,
                  icon: Icon(TablerIcons.edit),
                ),
              ],
            ),
            Wrap(
              spacing: 6,
              runSpacing: 2,
              children: [
                Chip(label: myRow('Sub Group', item.subgroup!.trim())),
                Chip(label: myRow('CBSE Ord', item.ord.toString())),
                Chip(label: myRow('Matric Ord', item.mOrd.toString())),
              ],
            ),
          ],
        ),
      );

  Widget myRow(String myKey, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$myKey : '),
        SizedBox(width: 4),
        MyChip(value, AppController.headColor),
      ],
    );
  }
}

class MyCheck extends ConsumerStatefulWidget {
  const MyCheck(
      {super.key, required this.isDark, required this.value, required this.id});
  final bool value;
  final bool isDark;
  final int id;

  @override
  ConsumerState<MyCheck> createState() => _MyCheckState();
}

class _MyCheckState extends ConsumerState<MyCheck> {
  bool isLoading = false;

  void toggle(val) async {
    setState(() {
      isLoading = true;
    });
    final res =
        await AppController.fetch('toggle-subject-show?id=${widget.id}');
    final data = jsonDecode(res);
    if (data['success']) {
      ref
          .read(subjectDetailsProvider.notifier)
          .updateShow(widget.id, data['data']);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.all(15),
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Checkbox(
            value: widget.value,
            activeColor: widget.isDark
                ? AppController.lightGreen
                : AppController.darkGreen,
            onChanged: toggle,
          );
  }
}
