import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/feedback_view_model.dart';

class FeedbackDetails extends StatelessWidget {
  const FeedbackDetails({super.key, required this.isDark, required this.snap});
  final FeedbackViewModel snap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sideWidth = 40.0 * 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        SizedBox(
          height: size.height * 0.8,
          child: DataTable2(
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
                  label: Column(
                    children: [Text(''), Divider(), Text('SL')],
                  ),
                  size: ColumnSize.S,
                  fixedWidth: sideWidth / 2.5,
                  headingRowAlignment: MainAxisAlignment.center),
              DataColumn2(
                  label: Column(
                    children: [
                      Text(''),
                      Divider(),
                      Text('Descriptors'),
                    ],
                  ),
                  size: ColumnSize.L,
                  fixedWidth: sideWidth * 4),
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
                fontSize: 12,
                color: isDark ? Colors.white : Colors.black),
            headingTextStyle: TextStyle(
                fontSize: 12.5,
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
                        DataCell(Center(child: Text(val))),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
