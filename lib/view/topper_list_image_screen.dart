import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/controller/topper_list_controller.dart';
import 'package:senthil/shimmer/search_shimmer.dart';
import 'package:senthil/widgets/topper_list-image/class_topper_image_card.dart';
import 'package:senthil/widgets/topper_list-image/subject_topper_image_table.dart';

class TopperListImageScreen extends ConsumerStatefulWidget {
  const TopperListImageScreen(
      {super.key, required this.index, required this.userId});
  final int index;
  final int userId;

  @override
  ConsumerState<TopperListImageScreen> createState() =>
      _TopperListImageScreenState();
}

class _TopperListImageScreenState extends ConsumerState<TopperListImageScreen> {
  final formKey = GlobalKey<FormState>();
  String? selectedClass, selectedYear, selectedCourse, selectedRefGroup;
  String? selectedExam, selectedStmGroup, selectedCrGroup;
  final cardKey = GlobalKey<ExpansionTileCoreState>();
  Object? data;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    TopperListController.setDataTopImage(
        ref, 'years-top-image', {'index': widget.index});
    super.initState();
  }

  void search() async {
    ref.read(TopperListController.searchingTop.notifier).state = true;
    selectedStmGroup ??= "None";
    selectedRefGroup ??= "None";
    selectedCrGroup ??= "None";
    data = {
      "index": widget.index,
      "year": selectedYear,
      "className": selectedClass,
      "exam": selectedExam,
      "courseGroup": selectedCrGroup,
      "stream": selectedStmGroup,
      "ref": selectedRefGroup
    };
    cardKey.currentState?.collapse();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    Size size = MediaQuery.of(context).size;

    final listener = data == null
        ? null
        : ref.watch(TopperListController.classTopperImageData(data!));

    List<Widget> dropdownList = [
      DropdownButtonFormField<String>(
        value: selectedYear,
        items: ref
            .watch(TopperListController.yearsTop)
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
          selectedExam = null;
          selectedStmGroup = null;
          TopperListController.setDataTopImage(ref, 'classes-top-image',
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
        decoration: InputDecoration(
            labelText: 'Class',
            prefixIcon: Icon(TablerIcons.chalkboard, color: Colors.grey)),
        onChanged: (val) {
          selectedClass = val;
          selectedCourse = null;
          selectedCrGroup = null;
          selectedExam = null;
          selectedStmGroup = null;
          TopperListController.setDataTopImage(ref, 'exams-top-image', {
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
                value: e ?? '',
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 220),
                    child: Text(e ?? 'None'))))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Exam',
            prefixIcon: Icon(TablerIcons.file_text, color: Colors.grey)),
        onChanged: (val) {
          selectedExam = val;
          selectedStmGroup = null;
          selectedCourse = null;
          selectedCrGroup = null;
          TopperListController.setDataTopImage(ref, 'courses-top-image', {
            'index': widget.index,
            'className': selectedClass,
            'userId': widget.userId
          });
          TopperListController.setDataTopImage(ref, 'course-group-top-image', {
            'index': widget.index,
            'className': selectedClass,
            'exam': selectedExam,
            'userId': widget.userId
          });
          TopperListController.setDataTopImage(ref, 'stream-group-top-image',
              {'index': widget.index, 'userId': widget.userId});
          TopperListController.setDataTopImage(ref, 'ref-group-top-image', {
            'index': widget.index,
            'className': selectedClass,
            'userId': widget.userId
          });
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
              labelText: 'Course Group',
              prefixIcon: Icon(Icons.group, color: Colors.grey)),
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
              labelText: 'stream group',
              prefixIcon: Icon(Icons.group, color: Colors.grey)),
          onChanged: (val) {
            selectedStmGroup = val;
          },
        ),
        DropdownButtonFormField<String>(
          value: selectedRefGroup,
          items: ref
              .watch(TopperListController.refGroupTop)
              .map((e) => DropdownMenuItem<String>(
                  value: e ?? '', child: Text(e ?? 'None')))
              .toList(),
          decoration: InputDecoration(
              labelText: 'Ref Group',
              prefixIcon: Icon(Icons.group, color: Colors.grey)),
          onChanged: (val) {
            selectedRefGroup = val;
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
            labelText: 'Course',
            prefixIcon: Icon(Icons.golf_course, color: Colors.grey)),
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Topper List Image'),
        actions: [
          IconButton(
            onPressed: () {
              scrollController.animateTo(100,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            },
            icon: Icon(Icons.arrow_upward),
          ),
          IconButton(
            onPressed: () {
              scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            },
            icon: Icon(Icons.arrow_downward),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: [
            if (ref.watch(TopperListController.yearsTop).isNotEmpty)
              AppController.animatedTitle(
                  '${widget.index == 0 ? 'CBSE' : "Metric"} School', isDark),
            SizedBox(height: 10),
            if (ref.watch(TopperListController.yearsTop).isNotEmpty)
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
            if (ref.watch(TopperListController.yearsTop).isNotEmpty)
              AppController.heading(
                  'Class Topper List', isDark, TablerIcons.list),
            SizedBox(height: 10),
            if (ref.watch(TopperListController.yearsTop).isNotEmpty)
              listener == null
                  ? SizedBox(
                      height: 200,
                      child:
                          Center(child: Text('Search to get class toppers!')),
                    )
                  : listener.when(
                      data: (snap) {
                        bool isTheOne = selectedClass == 'XI' ||
                            selectedClass == 'XI*' ||
                            selectedClass == 'XII' ||
                            selectedClass == 'XII*';

                        TextStyle style = TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppController.darkGreen);

                        Widget commonText = Text.rich(
                          TextSpan(
                            text: 'Comparison of Result for class ',
                            children: [
                              TextSpan(text: '$selectedClass ', style: style),
                              TextSpan(text: 'for '),
                              TextSpan(text: '$selectedExam ', style: style),
                              TextSpan(text: '/ Exam for '),
                              TextSpan(text: '$selectedYear', style: style),
                            ],
                          ),
                        );

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isTheOne)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Note : (ClassName / Course / Stream / Group)',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: 'Comparison of Result for class ',
                                      children: [
                                        TextSpan(
                                            text: '$selectedClass ',
                                            style: style),
                                        TextSpan(text: '/'),
                                        TextSpan(
                                            text: '$selectedCrGroup ',
                                            style: style),
                                        TextSpan(text: 'for '),
                                        TextSpan(
                                            text: '$selectedExam ',
                                            style: style),
                                        TextSpan(text: '/ Exam for '),
                                        TextSpan(
                                            text: '$selectedYear',
                                            style: style),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            else
                              commonText,
                            ClassTopperImageCard(snap: snap, isDark: isDark),
                            SizedBox(height: 20),
                            AppController.heading('Subject Wise Topper List',
                                isDark, TablerIcons.list),
                            SizedBox(height: 10),
                            commonText,
                            SizedBox(height: 10),
                            SubjectTopperImageTable(snap: snap, isDark: isDark)
                          ],
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
