import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/model/consistency_model.dart';

class ConsistencyTable extends StatelessWidget {
  const ConsistencyTable(
      {super.key,
      required this.snap,
      required this.isDark,
      required this.schoolIndex});

  final ConsistencyModel snap;
  final bool isDark;
  final int schoolIndex;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isLargeScreen = size.width > 800;

    return Expanded(
      child: Builder(builder: (context) {
        final school = snap.schools[schoolIndex];
        final schoolShort = school.short;
        final schoolResults = snap.results[schoolShort];
        if (schoolResults == null || schoolResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(TablerIcons.table_off, size: 50, color: Colors.grey),
                const SizedBox(height: 10),
                const Text('No records found!')
              ],
            ),
          );
        }
        final examNames = snap.examNames.map((e) => e.shortname).toList();
        List<StudentRow> studentRows = [];
        for (var examName in examNames) {
          final examData = schoolResults[examName] ?? [];
          for (var student in examData) {
            var existingRow = studentRows.firstWhere(
              (row) => row.studentName == student['studentname'],
              orElse: () => StudentRow(
                studentName: student['studentname'],
                admNo: student['adm_no'],
                sectionName: student['SectionName'] ?? '',
                examScores: {},
              ),
            );
            if (!studentRows.contains(existingRow)) {
              studentRows.add(existingRow);
            }
            existingRow.examScores[examName] = {
              'totmark': student['totmark'],
              'rank': student['rank'],
            };
          }
        }

        if (studentRows.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(TablerIcons.table_off, size: 50, color: Colors.grey),
                const SizedBox(height: 10),
                const Text('No records found!')
              ],
            ),
          );
        }
        double studentColumnWidth = size.width < 500 ? size.width * 0.40 : 200;

        List<DataColumn2> columns = [
          DataColumn2(
            label: const Text('Student Name'),
            size: ColumnSize.L,
            fixedWidth: studentColumnWidth,
            headingRowAlignment: MainAxisAlignment.center,
          ),
        ];

        if (isLargeScreen) {
          columns.addAll([
            DataColumn2(
              label: const Text('Adm No'),
              size: ColumnSize.M,
              fixedWidth: 120,
              headingRowAlignment: MainAxisAlignment.center,
            ),
            DataColumn2(
              label: const Text('Section'),
              size: ColumnSize.M,
              fixedWidth: 100,
              headingRowAlignment: MainAxisAlignment.center,
            ),
          ]);
        }

        columns.addAll([
          for (var examName in examNames)
            DataColumn2(
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Tooltip(
                      message: examName,
                      triggerMode: TooltipTriggerMode.tap,
                      child: Text(
                        examName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const Divider(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Total Mark'),
                        SizedBox(width: 5),
                        Text('Rank'),
                      ],
                    ),
                  ],
                ),
              ),
              size: ColumnSize.L,
              headingRowAlignment: MainAxisAlignment.center,
            ),
        ]);

        return DataTable2(
          border: TableBorder.all(color: Colors.grey),
          columnSpacing: 12,
          headingRowHeight: 68,
          horizontalMargin: 12,
          minWidth:
              ((size.width < 500 ? size.width : 260) * examNames.length) * 0.8,
          headingRowColor: WidgetStatePropertyAll(AppController.tableColor),
          fixedColumnsColor: AppController.tableColor,
          dataRowHeight: 60,
          fixedLeftColumns: isLargeScreen ? 3 : 1,
          fixedTopRows: 1,
          columns: columns,
          dataTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: isDark ? Colors.white : Colors.black),
          headingTextStyle: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black),
          rows: [
            for (var studentRow in studentRows)
              DataRow(
                cells: [
                  _buildStudentNameCell(studentRow, isLargeScreen),
                  if (isLargeScreen) ...[
                    DataCell(
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          child: Text(
                            studentRow.admNo,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(2),
                          child: Text(
                            studentRow.sectionName.isNotEmpty
                                ? studentRow.sectionName
                                : '-',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                  ],
                  for (var examName in examNames)
                    DataCell(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(studentRow.examScores[examName] != null
                              ? '${studentRow.examScores[examName]!['totmark']}'
                              : '-'),
                          const SizedBox(width: 5),
                          Text(studentRow.examScores[examName] != null
                              ? '${studentRow.examScores[examName]!['rank']}'
                              : '-'),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        );
      }),
    );
  }

  DataCell _buildStudentNameCell(StudentRow studentRow, bool isLargeScreen) {
    if (isLargeScreen) {
      return DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                studentRow.studentName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    } else {
      return DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                studentRow.studentName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: isDark
                                ? AppController.lightBlue
                                : const Color(0xFF1E90FF)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      studentRow.admNo,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppController.darkGreen),
                    child: Text(
                      studentRow.sectionName.isNotEmpty
                          ? studentRow.sectionName
                          : '-',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}

class StudentRow {
  final String studentName;
  final String admNo;
  final String sectionName;
  final Map<String, Map<String, dynamic>> examScores;

  StudentRow({
    required this.studentName,
    required this.admNo,
    required this.sectionName,
    required this.examScores,
  });
}
