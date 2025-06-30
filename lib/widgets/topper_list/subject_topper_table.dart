import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/controller/topper_list_controller.dart';
import 'package:senthil/model/topper_list_model.dart';

class SubjectTopperTable extends StatelessWidget {
  const SubjectTopperTable(
      {super.key, required this.snap, required this.isDark});

  final TopperListModel snap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.7,
      child: DataTable2(
        border: TableBorder.all(color: Colors.grey),
        columnSpacing: 12,
        horizontalMargin: 12,
        headingRowColor:
            WidgetStatePropertyAll(const Color.fromARGB(43, 255, 214, 64)),
        fixedColumnsColor: const Color.fromARGB(40, 255, 214, 64),
        fixedLeftColumns: 1,
        fixedTopRows: 1,
        columns: [
          DataColumn2(
              label: Text('Subject'),
              size: ColumnSize.L,
              headingRowAlignment: MainAxisAlignment.center),
          for (var school in snap.data.subToppers.schools)
            DataColumn2(
                label: Text(school ?? 'None'),
                headingRowAlignment: MainAxisAlignment.center),
        ],
        rows: [
          for (var titleWithVal in snap.data.subToppers.subList)
            DataRow(
              cells: [
                DataCell(Center(
                  child: Builder(builder: (context) {
                    final name = titleWithVal.subject.subjectName;
                    return Text(name == 'Mathematics' ? 'Maths' : name);
                  }),
                )),
                if (titleWithVal.value.isEmpty)
                  for (var e = 0; e < snap.data.subToppers.schools.length; e++)
                    DataCell(Center(child: Text('-')))
                else
                  for (var countList in titleWithVal.value)
                    DataCell(Center(
                      child: Builder(builder: (context) {
                        final isAvail = countList.topData
                            .where((e) => e.filename.toString().isNotEmpty)
                            .toList()
                            .isNotEmpty;
                        return InkWell(
                          onTap: () {
                            if (isAvail) {
                              TopperListController.listDocs(
                                  context, countList.topData, isDark);
                            }
                          },
                          child: Text(
                            '${countList.top == null ? '0' : countList.top!.max} (${countList.topData.length})',
                            style: TextStyle(
                                color: isAvail
                                    ? isDark
                                        ? AppController.lightBlue
                                        : baseColor
                                    : null),
                          ),
                        );
                      }),
                    )),
              ],
            ),
        ],
      ),
    );
  }
}
