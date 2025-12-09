import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/feedback_view_model.dart';
import 'package:senthil/view/stud_feedback/rating_details_screen.dart';

class FeedbackDetails extends StatelessWidget {
  const FeedbackDetails({super.key, required this.isDark, required this.snap});
  final FeedbackViewModel snap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sideWidth = 40.0 * 2;

    return Container(
      height: size.height * 0.8,
      decoration: BoxDecoration(border: Border.all()),
      child: snap.data.feedbackTab1.feedbackCounts.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.format_list_bulleted, size: 50),
                  SizedBox(height: 10),
                  Text('No records found!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Unable to load the contents.',
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
                ],
              ),
            )
          : DataTable2(
              border: TableBorder.all(color: Colors.grey),
              columnSpacing: 12,
              headingRowHeight: 80,
              horizontalMargin: 12,
              minWidth: size.width * (snap.data.feedbackSubjects.length + 2),
              headingRowColor: WidgetStatePropertyAll(AppController.tableColor),
              fixedColumnsColor: AppController.tableColor,
              dataRowHeight: 60,
              fixedLeftColumns: 1,
              fixedTopRows: 1,
              columns: [
                DataColumn2(
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Text(''), Divider(), Text('SL')],
                      ),
                    ),
                    size: ColumnSize.S,
                    fixedWidth: sideWidth / 2.5,
                    headingRowAlignment: MainAxisAlignment.center),
                DataColumn2(
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Text(''), Divider(), Text('Descriptors')],
                      ),
                    ),
                    size: ColumnSize.L,
                    fixedWidth: snap.data.feedbackSubjects.isEmpty
                        ? size.width
                        : sideWidth * 4),
                for (var sub in snap.data.feedbackSubjects)
                  DataColumn2(
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Tooltip(
                              message: sub.shortname,
                              triggerMode: TooltipTriggerMode.tap,
                              child: Text(sub.shortname,
                                  overflow: TextOverflow.ellipsis, maxLines: 1),
                            ),
                            Divider(),
                            Tooltip(
                              message: sub.staffName,
                              triggerMode: TooltipTriggerMode.tap,
                              child: Text(sub.staffName,
                                  overflow: TextOverflow.ellipsis, maxLines: 1),
                            )
                          ],
                        ),
                      ),
                      fixedWidth:
                          size.width > 450 ? 200 : size.width - (sideWidth * 3),
                      headingRowAlignment: MainAxisAlignment.center),
              ],
              dataTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isDark ? Colors.white : Colors.black),
              headingTextStyle: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black),
              rows: [
                for (var feed in snap.data.feedbackTab1.feedbackCounts)
                  DataRow(
                    cells: [
                      DataCell(Center(child: Text('${feed.feedback.id}'))),
                      DataCell(Text(feed.feedback.subject)),
                      if (feed.feedbackValues.isEmpty)
                        for (var e = 0;
                            e < snap.data.feedbackSubjects.length;
                            e++)
                          DataCell(Center(child: Text('-')))
                      else
                        for (var val in feed.feedbackValues)
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                final ids = snap.data.feedbackStudents;
                                final indexOf =
                                    feed.feedbackValues.indexOf(val);
                                final subIs =
                                    snap.data.feedbackSubjects[indexOf];
                                Get.to(
                                  () => RatingDetailsScreen(
                                    fId: feed.feedback.id,
                                    ids: ids,
                                    sId: subIs.id,
                                    isDark: isDark,
                                  ),
                                  transition: Transition.zoom,
                                );
                              },
                              child: Center(
                                child: Text('$val',
                                    style: TextStyle(
                                      color: isDark
                                          ? AppController.lightBlue
                                          : baseColor,
                                    )),
                              ),
                            ),
                          ),
                    ],
                  ),
                DataRow(
                  color: WidgetStatePropertyAll(AppController.tableColor),
                  cells: [
                    DataCell(Text('')),
                    DataCell(
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text("Total Marks Scored")),
                    ),
                    for (var tot in snap.data.feedbackTab1.totalMarks)
                      DataCell(Center(child: Text('$tot'))),
                  ],
                ),
                DataRow(
                  color: WidgetStatePropertyAll(AppController.tableColor),
                  cells: [
                    DataCell(Text('')),
                    DataCell(
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text("No Of Students")),
                    ),
                    for (var no in snap.data.feedbackTab1.noOfStudents)
                      DataCell(Center(child: Text('$no'))),
                  ],
                ),
                DataRow(
                  color: WidgetStatePropertyAll(AppController.tableColor),
                  cells: [
                    DataCell(Text('')),
                    DataCell(
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              "Total (${snap.data.feedbackTab1.feedbackTotal.mark} Marks) %")),
                    ),
                    for (var tot
                        in snap.data.feedbackTab1.feedbackTotal.percentage)
                      DataCell(Center(child: Text('$tot'))),
                  ],
                ), /*
          DataRow(
            color: WidgetStatePropertyAll(AppController.tableColor),
            cells: [
              DataCell(Text('')),
              DataCell(
                Align(
                    alignment: Alignment.centerRight,
                    child: Text("Total Converted To %")),
              ),
              for (var per in snap.data.feedbackTab1.feedbackPercent)
                DataCell(Center(child: Text('$per'))),
            ],
          ),*/
              ],
            ),
    );
  }
}
