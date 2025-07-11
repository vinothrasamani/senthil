import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/consistency_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/shimmer/search_shimmer.dart';
import 'package:senthil/widgets/consistency_table.dart';

class ConsistencyScreen extends ConsumerStatefulWidget {
  const ConsistencyScreen(
      {super.key, required this.index, required this.userId});
  final int index;
  final int userId;

  @override
  ConsumerState<ConsistencyScreen> createState() => _ConsistencyScreenState();
}

class _ConsistencyScreenState extends ConsumerState<ConsistencyScreen> {
  final formKey = GlobalKey<FormState>();
  String? selectedClass, selectedYear, selectedCourse, selectedRefGroup;
  String? selectedStmGroup, selectedCrGroup;
  Object? data;
  final cardKey = GlobalKey<ExpansionTileCoreState>();

  @override
  void initState() {
    ConsistencyController.setConData(
        ref, 'con-years', {'index': widget.index, 'id': widget.userId});
    super.initState();
  }

  void search() async {
    ref.read(ConsistencyController.searchingTop.notifier).state = true;
    selectedStmGroup ??= "All";
    selectedRefGroup ??= "All";
    selectedCrGroup ??= "All";
    data = {
      'id': widget.userId,
      "index": widget.index,
      "year": selectedYear,
      "className": selectedClass,
      "courseGroup": selectedCrGroup,
      "stream": selectedStmGroup,
      "ref": selectedRefGroup
    };
    cardKey.currentState?.collapse();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    Size size = MediaQuery.of(context).size;

    final listener =
        data == null ? null : ref.watch(ConsistencyController.conData(data!));

    List<Widget> dropdownList = [
      DropdownButtonFormField<String>(
        value: selectedYear,
        items: ref
            .watch(ConsistencyController.conYears)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Year',
            prefixIcon: Icon(
              TablerIcons.calendar_smile,
              color: Colors.grey,
            )),
        onChanged: (val) {
          selectedYear = val;
          selectedClass = null;
          selectedCourse = null;
          selectedCrGroup = null;
          selectedStmGroup = null;
          ConsistencyController.setConData(
              ref, 'con-classes', {'index': widget.index, 'id': widget.userId});
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedClass,
        items: ref
            .watch(ConsistencyController.conClasses)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Class',
            prefixIcon: Icon(
              TablerIcons.chalkboard,
              color: Colors.grey,
            )),
        onChanged: (val) {
          selectedClass = val;
          selectedCourse = null;
          selectedCrGroup = null;
          selectedStmGroup = null;
          ConsistencyController.setConData(ref, 'con-courses', {
            'index': widget.index,
            'className': selectedClass,
            'id': widget.userId
          });
          ConsistencyController.setConData(ref, 'con-course-group',
              {'index': widget.index, 'className': selectedClass});
          ConsistencyController.setConData(ref, 'con-stream-group',
              {'index': widget.index, 'className': selectedClass});
          ConsistencyController.setConData(ref, 'con-ref-group',
              {'index': widget.index, 'className': selectedClass});
          if (selectedClass == "XI" || selectedClass == "XII") {
            ref.read(ConsistencyController.canAddTop.notifier).state = true;
          } else {
            ref.read(ConsistencyController.canAddTop.notifier).state = false;
          }
        },
      ),
      if (ref.watch(ConsistencyController.canAddTop)) ...[
        DropdownButtonFormField<String>(
          value: selectedCrGroup,
          items: ref
              .watch(ConsistencyController.conCoursegroups)
              .map((e) => DropdownMenuItem<String>(
                  value: e ?? '', child: Text(e ?? 'None')))
              .toList(),
          decoration: InputDecoration(
              labelText: 'Course Group',
              prefixIcon: Icon(Icons.group, color: Colors.grey)),
          onChanged: (val) {
            selectedCrGroup = val;
          },
        ),
        DropdownButtonFormField<String>(
          value: selectedStmGroup,
          items: ref
              .watch(ConsistencyController.conStreamgroups)
              .map((e) => DropdownMenuItem<String>(
                  value: e ?? '', child: Text(e ?? 'None')))
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
              .watch(ConsistencyController.conRefGroup)
              .map((e) => DropdownMenuItem<String>(
                  value: e ?? '', child: Text(e ?? 'None')))
              .toList(),
          decoration: InputDecoration(
              labelText: 'Ref group',
              prefixIcon: Icon(Icons.group, color: Colors.grey)),
          onChanged: (val) {
            selectedRefGroup = val;
          },
        ),
      ],
      DropdownButtonFormField<String>(
        value: selectedCourse,
        items: ref
            .watch(ConsistencyController.conCourses)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Course',
            prefixIcon: Icon(Icons.golf_course, color: Colors.grey)),
        onChanged: (val) {
          selectedCourse = val;
        },
      ),
      Builder(builder: (context) {
        bool searching = ref.watch(ConsistencyController.searchingTop);
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
      appBar: AppBar(title: Text('Consistency')),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: [
            if (ref.watch(ConsistencyController.conYears).isNotEmpty)
              AppController.animatedTitle(
                  '${widget.index == 0 ? 'CBSE' : "Metric"} School', isDark),
            SizedBox(height: 10),
            if (ref.watch(ConsistencyController.conYears).isNotEmpty)
              Form(
                key: formKey,
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
                                    : size.width < 1020
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
            if (ref.watch(ConsistencyController.conYears).isNotEmpty)
              listener == null
                  ? SizedBox(
                      height: 200,
                      child: Center(
                          child: Text(
                              'Search to Know the Consistency of students!')),
                    )
                  : listener.when(
                      data: (snap) {
                        Widget commonText(school) => Text.rich(
                              TextSpan(
                                text: 'Consistency Results of class ',
                                children: [
                                  TextSpan(
                                    text:
                                        '$selectedClass ($school School) $selectedYear',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppController.darkGreen),
                                  ),
                                ],
                              ),
                            );

                        return DefaultTabController(
                          length: snap.data.schools.length,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TabBar(
                                isScrollable:
                                    snap.data.schools.length > 4 ? true : false,
                                tabAlignment: snap.data.schools.length > 4
                                    ? TabAlignment.start
                                    : null,
                                labelStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                labelColor: AppController.headColor,
                                indicatorColor: AppController.darkGreen,
                                dividerColor: Colors.grey.withAlpha(30),
                                tabs: [
                                  for (var item in snap.data.schools)
                                    Tab(text: item.school),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.8,
                                child: TabBarView(
                                  children: [
                                    for (var item in snap.data.schools)
                                      Builder(builder: (context) {
                                        final index =
                                            snap.data.schools.indexOf(item);
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10),
                                            AppController.heading(
                                                'Exam Result Student Consistency',
                                                isDark,
                                                TablerIcons.chart_donut),
                                            SizedBox(height: 10),
                                            commonText(item.school),
                                            SizedBox(height: 10),
                                            ConsistencyTable(
                                                snap: snap,
                                                isDark: isDark,
                                                index: index)
                                          ],
                                        );
                                      }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      error: (e, _) => SizedBox(
                        height: 200,
                        child: Center(child: Text('Something went wrong!')),
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
