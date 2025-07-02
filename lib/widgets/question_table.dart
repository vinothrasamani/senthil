import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/question_model.dart';
import 'package:senthil/view/pdf_viewer_screen.dart';

class QuestionTable extends StatelessWidget {
  const QuestionTable(
      {super.key,
      required this.snap,
      required this.isDark,
      required this.index});

  final QuestionModel snap;
  final bool isDark;
  final int index;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Expanded(
      child: Builder(builder: (context) {
        double sideWidth = 40.0 * 2;
        if (snap.data[index].details.isEmpty) {
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
        bool island = size.width > size.height || size.width > 500;
        TextStyle textStyle = TextStyle(color: baseColor);

        return DataTable2(
          border: TableBorder.all(color: Colors.grey),
          columnSpacing: 12,
          headingRowHeight: 60,
          horizontalMargin: 12,
          minWidth: island ? null : size.width * 4,
          headingRowColor:
              WidgetStatePropertyAll(const Color.fromARGB(43, 255, 214, 64)),
          fixedColumnsColor: const Color.fromARGB(40, 255, 214, 64),
          dataRowHeight: 60,
          fixedLeftColumns: 2,
          fixedTopRows: 1,
          columns: [
            DataColumn2(
              label: Text('SL'),
              size: ColumnSize.S,
              fixedWidth: sideWidth / 2,
              headingRowAlignment: MainAxisAlignment.center,
            ),
            DataColumn2(
              label: Text('Subject'),
              size: ColumnSize.M,
              fixedWidth: sideWidth,
              headingRowAlignment: MainAxisAlignment.center,
            ),
            DataColumn2(
              label: Text('Question Paper'),
              size: ColumnSize.L,
              fixedWidth: island ? null : sideWidth * 2.5,
              headingRowAlignment: MainAxisAlignment.center,
            ),
            DataColumn2(
              label: Text('Marking Scheme'),
              size: ColumnSize.L,
              fixedWidth: island ? null : sideWidth * 2.5,
              headingRowAlignment: MainAxisAlignment.center,
            ),
          ],
          dataTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: isDark ? Colors.white : Colors.black),
          headingTextStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black),
          rows: [
            for (var stud in snap.data[index].details)
              DataRow(
                cells: [
                  DataCell(Center(
                    child: Text(
                      '${stud.subject.ord}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
                  DataCell(Center(
                    child: Text(
                      stud.subject.subjectName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
                  DataCell(Builder(builder: (context) {
                    bool isAvail = stud.info.examQuestion != null;
                    return GestureDetector(
                      onTap: isAvail
                          ? () => Get.to(() => PdfViewerScreen(
                              fileName: stud.info.examQuestion!))
                          : null,
                      child: Text(
                        stud.info.examQuestion ?? "None",
                        maxLines: 2,
                        style: isAvail ? textStyle : null,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  })),
                  DataCell(Builder(builder: (context) {
                    bool isAvail = stud.info.markingScheme != null;
                    return GestureDetector(
                      onTap: isAvail
                          ? () => Get.to(() => PdfViewerScreen(
                              fileName: stud.info.markingScheme!))
                          : null,
                      child: Text(
                        stud.info.markingScheme ?? "None",
                        maxLines: 2,
                        style: isAvail ? textStyle : null,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  })),
                ],
              ),
          ],
        );
      }),
    );
  }
}
