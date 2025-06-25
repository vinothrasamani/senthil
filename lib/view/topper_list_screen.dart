import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/controller/topper_list_controller.dart';
import 'package:senthil/model/class_topper_list_model.dart';
import 'package:senthil/shimmer/comparison_shimmer.dart';

class TopperListScreen extends ConsumerStatefulWidget {
  const TopperListScreen(
      {super.key, required this.index, required this.userId});
  final int index;
  final int userId;

  @override
  ConsumerState<TopperListScreen> createState() => _TopperListScreenState();
}

class _TopperListScreenState extends ConsumerState<TopperListScreen> {
  final formKey = GlobalKey<FormState>();
  String? selectedClass, selectedYear, selectedCourse, selectedRefGroup;
  String? selectedExam, selectedStmGroup, selectedCrGroup;
  Object? data;

  @override
  void initState() {
    TopperListController.setDataTop(ref, 'years-top', {'index': widget.index});
    super.initState();
  }

  void search() async {
    ref.read(TopperListController.searchingTop.notifier).state = true;
    selectedStmGroup ??= "All";
    selectedRefGroup ??= "All";
    selectedCrGroup ??= "All";
    data = {
      "index": widget.index,
      "year": selectedYear,
      "className": selectedClass,
      "exam": selectedExam,
      "courseGroup": selectedCrGroup,
      "stream": selectedStmGroup,
      "ref": selectedRefGroup
    };
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    Size size = MediaQuery.of(context).size;

    final listener = data == null
        ? null
        : ref.watch(TopperListController.classTopperData(data!));

    List<Widget> dropdownList = [
      DropdownButtonFormField<String>(
        value: selectedYear,
        items: ref
            .watch(TopperListController.yearsTop)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Year', prefixIcon: Icon(Icons.date_range)),
        onChanged: (val) {
          selectedYear = val;
          selectedClass = null;
          selectedCourse = null;
          selectedCrGroup = null;
          selectedExam = null;
          selectedStmGroup = null;
          TopperListController.setDataTop(ref, 'classes-top',
              {'index': widget.index, 'userId': widget.userId});
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedClass,
        items: ref
            .watch(TopperListController.classesTop)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration:
            InputDecoration(labelText: 'Class', prefixIcon: Icon(Icons.class_)),
        onChanged: (val) {
          selectedClass = val;
          selectedCourse = null;
          selectedCrGroup = null;
          selectedExam = null;
          selectedStmGroup = null;
          TopperListController.setDataTop(ref, 'exams-top', {
            'index': widget.index,
            'className': val,
            'userId': widget.userId
          });
          if (selectedClass == "XI" ||
              selectedClass == "XI*" ||
              selectedClass == "XII" ||
              selectedClass == "XII*") {
            ref.read(TopperListController.canAddTop.notifier).state = true;
          } else {
            ref.read(TopperListController.canAddTop.notifier).state = false;
          }
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedExam,
        items: ref
            .watch(TopperListController.examsTop)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Exam', prefixIcon: Icon(Icons.insert_drive_file)),
        onChanged: (val) {
          selectedExam = val;
          selectedStmGroup = null;
          selectedCourse = null;
          selectedCrGroup = null;
          TopperListController.setDataTop(ref, 'courses-top', {
            'index': widget.index,
            'className': selectedClass,
            'userId': widget.userId
          });
          TopperListController.setDataTop(ref, 'course-group-top', {
            'index': widget.index,
            'className': selectedClass,
            'exam': selectedExam,
            'userId': widget.userId
          });
          TopperListController.setDataTop(ref, 'stream-group-top',
              {'index': widget.index, 'userId': widget.userId});
        },
      ),
      if (ref.watch(TopperListController.canAddTop)) ...[
        DropdownButtonFormField<String>(
          value: selectedCrGroup,
          items: ref
              .watch(TopperListController.coursegroupsTop)
              .map((e) => DropdownMenuItem<String>(
                  value: e ?? '', child: Text(e ?? 'None')))
              .toList(),
          decoration: InputDecoration(
              labelText: 'Course Group', prefixIcon: Icon(Icons.group)),
          onChanged: (val) {
            selectedCrGroup = val;
          },
        ),
        DropdownButtonFormField<String>(
          value: selectedStmGroup,
          items: ref
              .watch(TopperListController.streamgroupsTop)
              .map((e) => DropdownMenuItem<String>(
                  value: e ?? '', child: Text(e ?? 'None')))
              .toList(),
          decoration: InputDecoration(
              labelText: 'stream group', prefixIcon: Icon(Icons.group)),
          onChanged: (val) {
            selectedStmGroup = val;
          },
        ),
      ],
      DropdownButtonFormField<String>(
        value: selectedCourse,
        items: ref
            .watch(TopperListController.coursesTop)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Course', prefixIcon: Icon(Icons.golf_course)),
        onChanged: (val) {
          selectedCourse = val;
        },
      ),
      Builder(builder: (context) {
        bool searching = ref.watch(TopperListController.searchingTop);
        return SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: searching ? null : search,
            child: Text(searching ? 'Searching...' : 'Search'),
          ),
        );
      }),
    ];

    Widget myRow(ListElement item, int index) => Builder(builder: (context) {
          String link = item.filename;
          TextStyle style1 = TextStyle(color: link.isEmpty ? null : baseColor);
          return GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppController.darkGreen,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(item.subjectName, style: style1),
                  SizedBox(width: 8),
                  Spacer(),
                  Text(item.value.toStringAsFixed(1), style: style1)
                ],
              ),
            ),
          );
        });

    Widget topperContent(ClassTopperListModel snap) => DefaultTabController(
          length: snap.data.clsToppers.length,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabBar(
                    // isScrollable: true,
                    // tabAlignment: TabAlignment.start,
                    labelStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    labelColor: AppController.headColor,
                    indicatorColor: AppController.darkGreen,
                    dividerColor: Colors.grey.withAlpha(30),
                    tabs: [
                      for (var topper in snap.data.clsToppers)
                        Tab(text: topper.school)
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.7,
                    child: TabBarView(children: [
                      for (var topper in snap.data.clsToppers)
                        ListView(
                          children: [
                            for (var data in topper.details)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: baseColor.withAlpha(50)),
                                    child: Text(
                                      'Rank ${data.rank}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  for (var details in data.topper)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 5),
                                      child: ExpansionTileItem.outlined(
                                        title:
                                            Text(details.list[0].studentName),
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              baseColor.withAlpha(150),
                                          backgroundImage: NetworkImage(details
                                                  .list[0].photo.isEmpty
                                              ? '${AppController.baseImageUrl}/placeholder.jpg'
                                              : '${AppController.basefileUrl}/${details.list[0].photo}'),
                                        ),
                                        children: [
                                          for (var item in details.list)
                                            myRow(item,
                                                details.list.indexOf(item)),
                                          SizedBox(height: 10),
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: AppController.red)),
                                            child: Text(
                                              details.list[0].subjectTeacher,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppController.red),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                ],
                              )
                          ],
                        ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title:
            Text('${widget.index == 0 ? 'CBSE' : "Metric"} School Topper List'),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: [
            if (ref.watch(TopperListController.yearsTop).isNotEmpty)
              Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppController.heading('search', isDark),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 5,
                      runSpacing: 10,
                      children: dropdownList
                          .map((child) => SizedBox(
                                width: size.width < 500
                                    ? null
                                    : size.width < 850
                                        ? (size.width / 2) - 15
                                        : (size.width / 3) - 15,
                                child: child,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              )
            else
              ComparisonShimmer(isDark: isDark),
            SizedBox(height: 30),
            if (ref.watch(TopperListController.yearsTop).isNotEmpty)
              AppController.heading('Class Topper List', isDark),
            SizedBox(height: 10),
            if (ref.watch(TopperListController.yearsTop).isNotEmpty)
              listener == null
                  ? SizedBox(
                      height: 200,
                      child: Center(
                        child: Text('Search to Continue!'),
                      ),
                    )
                  : listener.when(
                      data: (snap) {
                        return topperContent(snap);
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
                    ),
          ],
        ),
      ),
    );
  }
}
