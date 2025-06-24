import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senthil/controller/comparison_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/shimmer/comparison_shimmer.dart';

class ComparisonScreen extends ConsumerStatefulWidget {
  const ComparisonScreen(
      {super.key, required this.index, required this.userId});
  final int index;
  final int userId;

  @override
  ConsumerState<ComparisonScreen> createState() => _ComparisonScreen();
}

class _ComparisonScreen extends ConsumerState<ComparisonScreen> {
  final formkey = GlobalKey<FormState>();
  String? selectedClass, selectedYear, selectedCourse, selectedCrGroup;
  String? selectedExam, selectedStmGroup, selectedRefGroup;
  Object? data;

  @override
  void initState() {
    ComparisonController.setData(ref, 'years', {'index': widget.index});
    super.initState();
  }

  void search() async {
    ref.read(ComparisonController.searching.notifier).state = true;
    selectedStmGroup ??= "All";
    selectedRefGroup ??= "None";
    selectedCrGroup ??= "All";
    data = {
      "academic_year": selectedYear,
      "exam_name": selectedExam,
      "class_name": selectedClass,
      "subject_name": '',
      "coursegroup": selectedCrGroup,
      "streamgroup": selectedStmGroup,
      "refgroup": selectedRefGroup,
      "course": selectedCourse,
      "index": widget.index,
      "userId": widget.userId
    };
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    Size size = MediaQuery.of(context).size;

    final listener =
        data == null ? null : ref.watch(ComparisonController.tableData(data!));

    Widget heading(String text) => Text(
          text,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDark ? Colors.blue : baseColor),
        );

    return Scaffold(
      appBar: AppBar(
          title: Text(
              '${widget.index == 0 ? 'CBSE' : 'Metric'} School Comparison')),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: [
            if (ref.watch(ComparisonController.years).isNotEmpty)
              Form(
                key: formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heading('search'),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 5,
                      children: [
                        DropdownButtonFormField<String>(
                          value: selectedYear,
                          items: ref
                              .watch(ComparisonController.years)
                              .map((e) => DropdownMenuItem<String>(
                                  value: e ?? '', child: Text(e ?? 'None')))
                              .toList(),
                          decoration: InputDecoration(
                              labelText: 'Year',
                              prefixIcon: Icon(Icons.date_range)),
                          onChanged: (val) {
                            selectedYear = val;
                            selectedClass = null;
                            selectedCourse = null;
                            selectedCrGroup = null;
                            selectedExam = null;
                            selectedStmGroup = null;
                            selectedRefGroup = null;
                            ComparisonController.setData(ref, 'classes', {
                              'index': widget.index,
                              'userId': widget.userId
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: selectedClass,
                          items: ref
                              .watch(ComparisonController.classes)
                              .map((e) => DropdownMenuItem<String>(
                                  value: e ?? '', child: Text(e ?? 'None')))
                              .toList(),
                          decoration: InputDecoration(
                              labelText: 'Class',
                              prefixIcon: Icon(Icons.class_)),
                          onChanged: (val) {
                            selectedClass = val;
                            selectedCourse = null;
                            selectedCrGroup = null;
                            selectedExam = null;
                            selectedStmGroup = null;
                            selectedRefGroup = null;
                            ComparisonController.setData(ref, 'exams', {
                              'index': widget.index,
                              'className': val,
                              'userId': widget.userId
                            });
                            if (selectedClass == "XI" ||
                                selectedClass == "XI*" ||
                                selectedClass == "XII" ||
                                selectedClass == "XII*") {
                              ref
                                  .read(ComparisonController.canAdd.notifier)
                                  .state = true;
                            } else {
                              ref
                                  .read(ComparisonController.canAdd.notifier)
                                  .state = false;
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: selectedExam,
                          items: ref
                              .watch(ComparisonController.exams)
                              .map((e) => DropdownMenuItem<String>(
                                  value: e ?? '', child: Text(e ?? 'None')))
                              .toList(),
                          decoration: InputDecoration(
                              labelText: 'Exam',
                              prefixIcon: Icon(Icons.insert_drive_file)),
                          onChanged: (val) {
                            selectedExam = val;
                            selectedStmGroup = null;
                            selectedRefGroup = null;
                            selectedCourse = null;
                            selectedCrGroup = null;
                            ComparisonController.setData(ref, 'courses', {
                              'index': widget.index,
                              'className': selectedClass,
                              'userId': widget.userId
                            });
                            ComparisonController.setData(ref, 'course-group', {
                              'index': widget.index,
                              'className': selectedClass,
                              'exam': selectedExam,
                              'userId': widget.userId
                            });
                            ComparisonController.setData(ref, 'stream-group', {
                              'index': widget.index,
                              'userId': widget.userId
                            });
                            ComparisonController.setData(ref, 'ref-group', {
                              'index': widget.index,
                              'className': selectedClass,
                              'userId': widget.userId
                            });
                          },
                        ),
                        if (ref.watch(ComparisonController.canAdd)) ...[
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedCrGroup,
                            items: ref
                                .watch(ComparisonController.coursegroups)
                                .map((e) => DropdownMenuItem<String>(
                                    value: e ?? '', child: Text(e ?? 'None')))
                                .toList(),
                            decoration: InputDecoration(
                                labelText: 'Course Group',
                                prefixIcon: Icon(Icons.group)),
                            onChanged: (val) {
                              selectedCrGroup = val;
                            },
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedStmGroup,
                            items: ref
                                .watch(ComparisonController.streamgroups)
                                .map((e) => DropdownMenuItem<String>(
                                    value: e ?? '', child: Text(e ?? 'None')))
                                .toList(),
                            decoration: InputDecoration(
                                labelText: 'stream group',
                                prefixIcon: Icon(Icons.group)),
                            onChanged: (val) {
                              selectedStmGroup = val;
                            },
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedRefGroup,
                            items: ref
                                .watch(ComparisonController.refgroups)
                                .map((e) => DropdownMenuItem<String>(
                                    value: e ?? '', child: Text(e ?? 'None')))
                                .toList(),
                            decoration: InputDecoration(
                                labelText: 'Ref Group',
                                prefixIcon: Icon(Icons.group)),
                            onChanged: (val) {
                              selectedRefGroup = val;
                            },
                          ),
                        ],
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: selectedCourse,
                          items: ref
                              .watch(ComparisonController.courses)
                              .map((e) => DropdownMenuItem<String>(
                                  value: e ?? '', child: Text(e ?? 'None')))
                              .toList(),
                          decoration: InputDecoration(
                              labelText: 'Course',
                              prefixIcon: Icon(Icons.golf_course)),
                          onChanged: (val) {
                            selectedCourse = val;
                          },
                        ),
                        SizedBox(height: 10),
                        Builder(builder: (context) {
                          bool searching =
                              ref.watch(ComparisonController.searching);
                          return SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: searching ? null : search,
                              child:
                                  Text(searching ? 'Searching...' : 'Search'),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              )
            else
              ComparisonShimmer(isDark: isDark),
            SizedBox(height: 30),
            if (ref.watch(ComparisonController.years).isNotEmpty)
              heading('Exam Result Comparison'),
            SizedBox(height: 10),
            if (ref.watch(ComparisonController.years).isNotEmpty)
              if (listener != null)
                listener.when(
                  data: (searchData) {
                    double sideWidth = 40.0 * searchData.data.schools.length;
                    return SizedBox(
                      height: size.height - 100,
                      child: DataTable2(
                        border: TableBorder.all(color: Colors.grey),
                        columnSpacing: 12,
                        headingRowHeight: 80,
                        horizontalMargin: 12,
                        minWidth: size.width * searchData.data.subjects.length,
                        headingRowColor: WidgetStatePropertyAll(
                            const Color.fromARGB(43, 255, 214, 64)),
                        fixedColumnsColor:
                            const Color.fromARGB(40, 255, 214, 64),
                        fixedLeftColumns: 1,
                        fixedTopRows: 1,
                        columns: [
                          DataColumn2(
                              label: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Subject'),
                                  Divider(),
                                  Text('Particular'),
                                ],
                              ),
                              size: ColumnSize.L,
                              fixedWidth: sideWidth),
                          for (var sub in searchData.data.subjects)
                            DataColumn2(
                                label: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(sub),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        for (var school
                                            in searchData.data.schools)
                                          Text(school.school),
                                      ],
                                    ),
                                  ],
                                ),
                                fixedWidth: size.width > 450
                                    ? 250
                                    : size.width - (sideWidth + 35)),
                        ],
                        rows: [
                          for (var titleWithVal in searchData.data.myValues)
                            DataRow(cells: [
                              DataCell(Text(titleWithVal.title)),
                              if (titleWithVal.myList.isEmpty)
                                for (var e = 0;
                                    e < searchData.data.subjects.length;
                                    e++)
                                  DataCell(Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      for (var c = 0;
                                          c < searchData.data.schools.length;
                                          c++)
                                        Text('0'),
                                    ],
                                  ))
                              else
                                for (var countList in titleWithVal.myList)
                                  DataCell(Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      for (var c in countList.counts)
                                        Text(
                                            '${c.value == "_" ? '0' : c.value}'),
                                    ],
                                  )),
                            ]),
                        ],
                      ),
                    );
                  },
                  error: (e, _) => SizedBox(
                    height: 200,
                    child: Center(
                        child: Text('Failed to fetch. Try again Later!')),
                  ),
                  loading: () => SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else
                SizedBox(
                  height: 200,
                  child: Center(child: Text('Search first then compare!')),
                )
            else
              SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
