import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/consistency_model.dart';

class ConsistencyTable extends StatelessWidget {
  const ConsistencyTable(
      {super.key,
      required this.snap,
      required this.isDark,
      required this.index});

  final ConsistencyModel snap;
  final bool isDark;
  final int index;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Expanded(
      child: Builder(builder: (context) {
        double sideWidth = 40.0 * 2;
        if (snap.data.schools[index].schoolData.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(TablerIcons.table_off, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Text('No records found!')
              ],
            ),
          );
        }
        return DataTable2(
          border: TableBorder.all(color: Colors.grey),
          columnSpacing: 12,
          headingRowHeight: 68,
          horizontalMargin: 12,
          minWidth: size.width * snap.data.exams.length,
          headingRowColor: WidgetStatePropertyAll(AppController.tableColor),
          fixedColumnsColor: AppController.tableColor,
          dataRowHeight: 60,
          fixedLeftColumns: 1,
          fixedTopRows: 1,
          columns: [
            DataColumn2(
                label: Text('Student Name'),
                size: ColumnSize.L,
                fixedWidth: sideWidth * 1.5,
                headingRowAlignment: MainAxisAlignment.center),
            for (var exam in snap.data.exams)
              DataColumn2(
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Tooltip(
                          message: exam,
                          triggerMode: TooltipTriggerMode.tap,
                          child: Text(exam,
                              overflow: TextOverflow.ellipsis, maxLines: 1),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Total Mark'),
                            SizedBox(width: 5),
                            Text('Rank')
                          ],
                        ),
                      ],
                    ),
                  ),
                  fixedWidth:
                      size.width > 450 ? 200 : size.width - (sideWidth * 2),
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
            for (var stud in snap.data.schools[index].schoolData)
              DataRow(
                cells: [
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            stud.details.studentName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: isDark
                                            ? AppController.lightBlue
                                            : baseColor),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  stud.details.adminno,
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                              SizedBox(width: 6),
                              Container(
                                width: 18,
                                height: 18,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppController.darkGreen),
                                child: Text(
                                  stud.details.sectionName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (stud.examData.isEmpty)
                    for (var e = 0; e < snap.data.exams.length; e++)
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('-'),
                          SizedBox(width: 5),
                          Text('-'),
                        ],
                      ))
                  else
                    for (var mark in stud.examData)
                      DataCell(Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('${mark.info?.value ?? '-'}'),
                          SizedBox(width: 5),
                          Text('${mark.info?.rank ?? '-'}'),
                        ],
                      )),
                ],
              ),
          ],
        );
      }),
    );
  }
}
