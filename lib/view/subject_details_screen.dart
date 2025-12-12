import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/subject_details_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/subject_details_model.dart';
import 'package:senthil/shimmer/list_shimmer.dart';
import 'package:senthil/widgets/common_error_widget.dart';

class SubjectDetailsScreen extends ConsumerWidget {
  const SubjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listener = ref.watch(subjectDetailsProvider);
    final size = MediaQuery.of(context).size;
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: Text('Subject Details')),
      body: SafeArea(
        child: listener.when(
          data: (snap) => ListView(
            padding: EdgeInsets.only(bottom: 80, left: 10, right: 10, top: 10),
            children: [
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  for (var item in snap)
                    SizedBox(
                      width: size.width > 850 ? (size.width / 2) - 25 : null,
                      child: myCard(context, item, isDark),
                    ),
                ],
              ),
            ],
          ),
          error: (error, _) => CommonErrorWidget(),
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
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              width: 1.5),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : Colors.grey).withAlpha(15),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [
                  MyCheck(isDark: isDark, value: item.show == 1, id: item.id),
                  SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.fullname,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.grey.shade900,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          item.subgroup?.trim() ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppController.lightBlue.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppController.lightBlue.withAlpha(100),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '📗 ${item.shortname}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppController.lightBlue,
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  IconButton.filledTonal(
                    onPressed: () {
                      SubjectDetailsController.openEditor(context, item);
                    },
                    style: IconButton.styleFrom(
                        backgroundColor: AppController.yellow.withAlpha(50)),
                    color: AppController.yellow,
                    icon: Icon(TablerIcons.edit),
                    iconSize: 18,
                    constraints: BoxConstraints(minWidth: 30, minHeight: 30),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            Container(
              height: 0.5,
              margin: EdgeInsets.symmetric(horizontal: 10),
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    label: 'Sub Group',
                    value: item.subgroup?.trim() ?? 'N/A',
                    isDark: isDark,
                  ),
                  _buildInfoChip(
                    label: 'CBSE Ord',
                    value: item.ord.toString(),
                    isDark: isDark,
                  ),
                  _buildInfoChip(
                    label: 'Matric Ord',
                    value: item.mOrd.toString(),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildInfoChip(
          {required String label,
          required String value,
          required bool isDark}) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
            SizedBox(width: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppController.headColor,
                ),
              ),
            ),
          ],
        ),
      );
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
