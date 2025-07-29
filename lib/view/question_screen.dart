import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/question_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/shimmer/search_shimmer.dart';
import 'package:senthil/shimmer/table_shimmer.dart';
import 'package:senthil/widgets/question_table.dart';

class QuestionScreen extends ConsumerStatefulWidget {
  const QuestionScreen({super.key, required this.index, required this.userId});
  final int index;
  final int userId;

  @override
  ConsumerState<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends ConsumerState<QuestionScreen> {
  final formKey = GlobalKey<FormState>();
  String? selectedClass, selectedYear, selectedExam;
  Object? data;
  final cardKey = GlobalKey<ExpansionTileCoreState>();

  @override
  void initState() {
    QuestionController.setQuesData(
        ref, 'ques-yec', {'index': widget.index, 'id': widget.userId});
    super.initState();
  }

  void search() async {
    ref.read(QuestionController.searchingTop.notifier).state = true;
    data = {
      "index": widget.index,
      "year": selectedYear,
      "className": selectedClass,
      "exam": selectedExam,
    };
    cardKey.currentState?.collapse();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    final size = MediaQuery.of(context).size;

    final listener =
        data == null ? null : ref.watch(QuestionController.questionData(data!));

    List<Widget> dropdownList = [
      DropdownButtonFormField<String>(
        value: selectedYear,
        items: ref
            .watch(QuestionController.quesYears)
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
          selectedExam = null;
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedExam,
        items: ref
            .watch(QuestionController.quesExams)
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
          selectedClass = null;
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedClass,
        items: ref
            .watch(QuestionController.quesClasses)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Class',
            prefixIcon: Icon(TablerIcons.chalkboard, color: Colors.grey)),
        onChanged: (val) {
          selectedClass = val;
        },
      ),
      Builder(builder: (context) {
        bool searching = ref.watch(QuestionController.searchingTop);
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
      appBar: AppBar(title: Text('Questions & M.Scheme')),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: [
            if (ref.watch(QuestionController.quesYears).isNotEmpty)
              AppController.animatedTitle(
                  '${widget.index == 0 ? 'CBSE' : "Metric"} School', isDark),
            SizedBox(height: 10),
            if (ref.watch(QuestionController.quesYears).isNotEmpty)
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
            if (ref.watch(QuestionController.quesYears).isNotEmpty)
              listener == null
                  ? SizedBox(
                      height: 200,
                      child: Center(child: Text('Search to get details!')),
                    )
                  : listener.when(
                      data: (snap) {
                        TextStyle style = TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppController.darkGreen);

                        Widget commonText(school) => Text.rich(
                              TextSpan(
                                text: '',
                                children: [
                                  TextSpan(
                                      text: '$selectedClass ', style: style),
                                  TextSpan(
                                      text:
                                          'Exam Question Paper & Marking Scheme '),
                                  TextSpan(
                                      text: '$school $selectedYear',
                                      style: style),
                                ],
                              ),
                            );

                        return DefaultTabController(
                          length: snap.data.length,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TabBar(
                                isScrollable:
                                    snap.data.length > 4 ? true : false,
                                tabAlignment: snap.data.length > 4
                                    ? TabAlignment.start
                                    : null,
                                labelStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                labelColor: AppController.headColor,
                                indicatorColor: AppController.darkGreen,
                                dividerColor: Colors.grey.withAlpha(30),
                                tabs: [
                                  for (var item in snap.data)
                                    Tab(text: item.school),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.8,
                                child: TabBarView(
                                  children: [
                                    for (var item in snap.data)
                                      Builder(builder: (context) {
                                        final index = snap.data.indexOf(item);
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10),
                                            AppController.heading(
                                                'Exam Question Paper & Marketing Scheme - ${item.school}',
                                                isDark,
                                                TablerIcons.file_text_spark),
                                            SizedBox(height: 10),
                                            commonText(item.school),
                                            SizedBox(height: 10),
                                            QuestionTable(
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
                      loading: () => TableShimmer(isDark: isDark),
                    ),
          ],
        ),
      ),
    );
  }
}
