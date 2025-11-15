import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/exam_upload_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/shimmer/table_shimmer.dart';

class ExamUploadDetailsScreen extends ConsumerStatefulWidget {
  const ExamUploadDetailsScreen({super.key, required this.index});
  final int index;

  @override
  ConsumerState<ExamUploadDetailsScreen> createState() =>
      _ExamUploadDetailsScreenState();
}

class _ExamUploadDetailsScreenState
    extends ConsumerState<ExamUploadDetailsScreen> {
  Widget name(String h, String b) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(h, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(' - $b', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  DataCell value(String val) {
    bool isDark = ref.read(ThemeController.themeMode) == ThemeMode.dark;
    return DataCell(Center(
      child: Text(
        val,
        style: TextStyle(
            color: (val == 'S/D/K' && widget.index == 0)
                ? isDark
                    ? AppController.lightGreen
                    : AppController.darkGreen
                : AppController.red),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    final listener =
        ref.watch(ExamUploadController.examUploadData(widget.index));

    return Scaffold(
      appBar: AppBar(title: Text('Exam Upload Details')),
      body: SafeArea(
        child: listener.when(
          data: (snap) {
            double sideWidth = 40.0 * 2;
            return ListView(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              children: [
                AppController.animatedTitle(
                    '${widget.index == 0 ? 'CBSE' : "Matric"} School', isDark),
                SizedBox(height: 10),
                AppController.heading(
                    'Uploaded Classes Only!', isDark, Icons.table_view),
                SizedBox(height: 10),
                Wrap(
                  spacing: 15,
                  children: [
                    name('S', 'Salem'),
                    name('D', 'Dharmapuri'),
                    name('K', 'Krishnagiri'),
                  ],
                ),
                SizedBox(height: 10),
                Row(children: [
                  Chip(
                      label: Text(
                    'Completed',
                    style: TextStyle(
                        color: isDark
                            ? AppController.lightGreen
                            : AppController.darkGreen),
                  )),
                  SizedBox(width: 8),
                  Chip(
                      label: Text(
                    'InCompleted',
                    style: TextStyle(color: AppController.red),
                  )),
                ]),
                SizedBox(height: 10),
                Container(
                  height: size.width > size.height
                      ? size.height * 0.65
                      : size.height * 0.8,
                  decoration: BoxDecoration(border: Border.all()),
                  child: DataTable2(
                    border: TableBorder.all(color: Colors.grey),
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: size.width > 600
                        ? size.width
                        : size.width * (snap.data.resSch.length + 2),
                    headingRowColor:
                        WidgetStatePropertyAll(AppController.tableColor),
                    fixedColumnsColor: AppController.tableColor,
                    fixedLeftColumns: 2,
                    fixedTopRows: 1,
                    columns: [
                      DataColumn2(
                          label: Text('SL'),
                          fixedWidth: sideWidth * 0.4,
                          headingRowAlignment: MainAxisAlignment.center),
                      DataColumn2(
                          label: Text('Exam Name'),
                          fixedWidth: size.width > 600 ? null : sideWidth * 1.4,
                          headingRowAlignment: MainAxisAlignment.center),
                      for (var school in snap.data.resSch)
                        DataColumn2(
                            label: Text(school),
                            fixedWidth: 60,
                            headingRowAlignment: MainAxisAlignment.center),
                    ],
                    dataTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isDark ? Colors.white : Colors.black),
                    headingTextStyle: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black),
                    rows: [
                      for (var item in snap.data.result)
                        DataRow(
                          cells: [
                            DataCell(Center(
                              child: Builder(builder: (context) {
                                final name = snap.data.result.indexOf(item) + 1;
                                return Text('$name');
                              }),
                            )),
                            DataCell(
                              Tooltip(
                                message: item.exam,
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: !isDark ? Colors.white : Colors.black,
                                ),
                                triggerMode: TooltipTriggerMode.tap,
                                child: Text(item.exam,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            value(item.i),
                            value(item.ii),
                            value(item.iii),
                            value(item.iv),
                            value(item.ix),
                            value(item.v),
                            value(item.vi),
                            value(item.vii),
                            value(item.viii),
                            value(item.x),
                            value(item.xi),
                            value(item.resultXi),
                            value(item.xii),
                            value(item.resultXii),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
          error: (e, _) => SizedBox(
            height: 200,
            child: Center(child: Text('Something went wrong!')),
          ),
          loading: () =>
              SingleChildScrollView(child: TableShimmer(isDark: isDark)),
        ),
      ),
    );
  }
}
