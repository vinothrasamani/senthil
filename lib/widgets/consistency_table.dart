import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
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
        return DataTable2(
          border: TableBorder.all(color: Colors.grey),
          columnSpacing: 12,
          headingRowHeight: 80,
          horizontalMargin: 12,
          minWidth: size.width * snap.data.exams.length,
          headingRowColor:
              WidgetStatePropertyAll(const Color.fromARGB(43, 255, 214, 64)),
          fixedColumnsColor: const Color.fromARGB(40, 255, 214, 64),
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
                  label: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(exam),
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
                  fixedWidth:
                      size.width > 450 ? 200 : size.width - (sideWidth * 2),
                  headingRowAlignment: MainAxisAlignment.center),
          ],
          dataTextStyle: TextStyle(fontSize: 12),
          headingTextStyle:
              TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          rows: [
            for (var stud in snap.data.schools[index].schoolData)
              DataRow(
                cells: [
                  DataCell(Text(stud.details.studentName)),
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
