import 'package:data_table_2/data_table_2.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/comparison_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/shimmer/search_shimmer.dart';
import 'package:senthil/shimmer/table_shimmer.dart';

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
  final cardKey = GlobalKey<ExpansionTileCoreState>();

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
    cardKey.currentState?.collapse();
  }

  @override
  void dispose() {
    cardKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    Size size = MediaQuery.of(context).size;

    final listener =
        data == null ? null : ref.watch(ComparisonController.tableData(data!));

    List<Widget> dropdownList = [
      DropdownButtonFormField<String>(
        value: selectedYear,
        items: ref
            .watch(ComparisonController.years)
            .map((e) =>
                DropdownMenuItem<String>(value: e ?? '', child: Text(e ?? '')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Year',
            prefixIcon: Icon(TablerIcons.calendar_smile, color: Colors.grey)),
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
            'year': val,
            'userId': widget.userId,
          });
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedClass,
        items: ref
            .watch(ComparisonController.classes)
            .map((e) =>
                DropdownMenuItem<String>(value: e ?? '', child: Text(e ?? '')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Class',
            prefixIcon: Icon(TablerIcons.chalkboard, color: Colors.grey)),
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
            'year': selectedYear,
            'userId': widget.userId
          });
          if (selectedClass == "XI" ||
              selectedClass == "XI*" ||
              selectedClass == "XII" ||
              selectedClass == "XII*") {
            ref.read(ComparisonController.canAdd.notifier).state = true;
          } else {
            ref.read(ComparisonController.canAdd.notifier).state = false;
          }
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedExam,
        items: ref
            .watch(ComparisonController.exams)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '',
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 220),
                  child: Text(
                    e ?? '',
                    overflow: TextOverflow.clip,
                  ),
                )))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Exam',
            prefixIcon: Icon(TablerIcons.file_text, color: Colors.grey)),
        onChanged: (val) {
          selectedExam = val;
          selectedStmGroup = null;
          selectedRefGroup = null;
          selectedCourse = null;
          selectedCrGroup = null;
          ComparisonController.setData(ref, 'courses', {
            'index': widget.index,
            'className': selectedClass,
            'year': selectedYear,
            'userId': widget.userId
          });
          ComparisonController.setData(ref, 'course-group', {
            'index': widget.index,
            'className': selectedClass,
            'exam': selectedExam,
            'year': selectedYear,
            'userId': widget.userId
          });
          ComparisonController.setData(ref, 'stream-group', {
            'index': widget.index,
            'userId': widget.userId,
            'year': selectedYear,
          });
          ComparisonController.setData(ref, 'ref-group', {
            'index': widget.index,
            'className': selectedClass,
            'year': selectedYear,
            'userId': widget.userId
          });
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedCrGroup,
        items: ref
            .watch(ComparisonController.coursegroups)
            .map((e) =>
                DropdownMenuItem<String>(value: e ?? '', child: Text(e ?? '')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Course Group',
            prefixIcon: Icon(Icons.group, color: Colors.grey)),
        onChanged: (val) {
          selectedCrGroup = val;
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedCourse,
        items: ref
            .watch(ComparisonController.courses)
            .map((e) =>
                DropdownMenuItem<String>(value: e ?? '', child: Text(e ?? '')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Main Course',
            prefixIcon: Icon(Icons.golf_course, color: Colors.grey)),
        onChanged: (val) {
          selectedCourse = val;
        },
      ),
      if (ref.watch(ComparisonController.canAdd)) ...[
        DropdownButtonFormField<String>(
          value: selectedStmGroup,
          items: ref
              .watch(ComparisonController.streamgroups)
              .map((e) => DropdownMenuItem<String>(
                  value: e ?? '', child: Text(e ?? '')))
              .toList(),
          decoration: InputDecoration(
              labelText: 'stream group',
              prefixIcon: Icon(Icons.group, color: Colors.grey)),
          onChanged: (val) {
            selectedStmGroup = val;
          },
        ),
        DropdownButtonFormField<String>(
          value: selectedRefGroup,
          items: ref
              .watch(ComparisonController.refgroups)
              .map((e) => DropdownMenuItem<String>(
                  value: e ?? '', child: Text(e ?? '')))
              .toList(),
          decoration: InputDecoration(
              labelText: 'Ref Group',
              prefixIcon: Icon(Icons.group, color: Colors.grey)),
          onChanged: (val) {
            selectedRefGroup = val;
          },
        ),
      ],
      Builder(builder: (context) {
        bool searching = ref.watch(ComparisonController.searching);
        return SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: searching ? null : search,
            child: Text(searching ? 'Searching...' : 'Search'),
          ),
        );
      }),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('School Comparison')),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: [
            if (ref.watch(ComparisonController.years).isNotEmpty)
              AppController.animatedTitle(
                  '${widget.index == 0 ? 'CBSE' : "Matric"} School', isDark),
            SizedBox(height: 10),
            if (ref.watch(ComparisonController.years).isNotEmpty)
              Form(
                key: formkey,
                child: ExpansionTileItem.outlined(
                  expansionKey: cardKey,
                  title: AppController.heading(
                      'Search', isDark, TablerIcons.search),
                  children: [
                    Wrap(
                      spacing: 5,
                      runSpacing: 10,
                      children: dropdownList
                          .map((child) => SizedBox(
                                width: size.width < 500
                                    ? null
                                    : size.width < 850
                                        ? (size.width / 2) - 30
                                        : (size.width / 3) - 30,
                                child: child,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              )
            else
              SearchShimmer(isDark: isDark),
            SizedBox(height: 20),
            if (ref.watch(ComparisonController.years).isNotEmpty)
              AppController.heading(
                  'Exam Result Comparison', isDark, TablerIcons.chart_dots),
            SizedBox(height: 10),
            if (ref.watch(ComparisonController.years).isNotEmpty)
              if (listener != null)
                listener.when(
                  data: (searchData) {
                    double sideWidth = searchData.data.schools.length >= 3
                        ? 40.0 * searchData.data.schools.length
                        : 40.0 * 3;
                    TextStyle style = TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppController.darkGreen);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Note : Class / Course / Stream / Group',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Comparison of Result for class ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text:
                                      '$selectedClass / All / $selectedStmGroup / $selectedStmGroup ',
                                  style: style),
                              TextSpan(text: 'for '),
                              TextSpan(text: '$selectedExam ', style: style),
                              TextSpan(text: '/ Exams for '),
                              TextSpan(text: selectedYear, style: style)
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        if (searchData.data.subjects.isNotEmpty)
                          SizedBox(
                            height: size.height - 100,
                            child: DataTable2(
                              border: TableBorder.all(color: Colors.grey),
                              columnSpacing: 12,
                              headingRowHeight: 80,
                              horizontalMargin: 12,
                              minWidth:
                                  size.width * searchData.data.subjects.length,
                              headingRowColor: WidgetStatePropertyAll(
                                  AppController.tableColor),
                              fixedColumnsColor: AppController.tableColor,
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
                                for (var titleWithVal
                                    in searchData.data.myValues)
                                  DataRow(
                                    cells: [
                                      DataCell(Text(titleWithVal.title)),
                                      if (titleWithVal.myList.isEmpty)
                                        for (var e = 0;
                                            e < searchData.data.subjects.length;
                                            e++)
                                          DataCell(
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                for (var c = 0;
                                                    c <
                                                        searchData.data.schools
                                                            .length;
                                                    c++)
                                                  Text('-'),
                                              ],
                                            ),
                                          )
                                      else
                                        for (var countList
                                            in titleWithVal.myList)
                                          DataCell(
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                for (var c in countList.counts)
                                                  Text('${c.value}'),
                                              ],
                                            ),
                                          ),
                                    ],
                                  ),
                              ],
                            ),
                          )
                        else
                          SizedBox(
                            height: 200,
                            child: Center(child: Text('No Results Found!')),
                          )
                      ],
                    );
                  },
                  error: (e, _) => SizedBox(
                    height: 200,
                    child: Center(
                        child: Text('Failed to fetch. Try again Later!')),
                  ),
                  loading: () => TableShimmer(isDark: isDark),
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
