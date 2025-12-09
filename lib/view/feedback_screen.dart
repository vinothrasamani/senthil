import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/feedback_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/feedback_entry_model.dart';
import 'package:senthil/shimmer/search_shimmer.dart';
import 'package:senthil/shimmer/table_shimmer.dart';
import 'package:senthil/widgets/feedback_view/feedback_details.dart';
import 'package:senthil/widgets/feedback_view/optional_feedback.dart';
import 'package:senthil/widgets/common_error_widget.dart';
import 'package:senthil/widgets/initializer_widget.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen(
      {super.key, required this.index, required this.userId, this.feedback});
  final int index;
  final int userId;
  final FeedbackEntry? feedback;

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final formKey = GlobalKey<FormState>();
  String? selectedYear, selectedClass, selectedSession;
  String? selectedsection, selectedSchool;
  final cardKey = GlobalKey<ExpansionTileCoreState>();
  int? selectedRefGroup;
  Object? data;

  @override
  void initState() {
    if (widget.feedback == null) {
      FeedbackController.loadinitials(ref, 'feedback-initials',
          {'index': widget.index, 'id': widget.userId});
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        selectedYear = widget.feedback!.feedbackyear;
        selectedClass = widget.feedback!.classname;
        selectedSession = widget.feedback!.feedbacksession;
        selectedsection = widget.feedback!.section;
        selectedSchool = widget.feedback!.school;
        selectedRefGroup = widget.feedback!.refgroup;
        ref.watch(FeedbackController.feedAvail.notifier).state = true;
        search();
      });
    }
    super.initState();
  }

  void search() async {
    ref.read(FeedbackController.searching.notifier).state = true;
    data = {
      "index": widget.index,
      "year": selectedYear,
      "className": selectedClass,
      "school": selectedSchool,
      "session": selectedSession,
      "section": selectedsection,
      'isStaff': ref.read(FeedbackController.isStaff),
      "refGroup": selectedRefGroup
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
    bool isStaff = ref.watch(FeedbackController.isStaff);

    final listener =
        data == null ? null : ref.watch(FeedbackController.searchData(data!));

    List<Widget> dropdownList = [
      DropdownButtonFormField<String>(
        value: selectedYear,
        items: ref
            .watch(FeedbackController.years)
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
          selectedSession = null;
          selectedSchool = null;
          selectedClass = null;
          selectedsection = null;
          selectedRefGroup = null;
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedSession,
        items: ref
            .watch(FeedbackController.sessions)
            .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Session',
            prefixIcon: Icon(
              Icons.timer,
              color: Colors.grey,
            )),
        onChanged: (val) {
          selectedSession = val;
          selectedSchool = null;
          selectedClass = null;
          selectedsection = null;
          selectedRefGroup = null;
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedSchool,
        items: ref
            .watch(FeedbackController.schools)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'School',
            prefixIcon: Icon(TablerIcons.school, color: Colors.grey)),
        onChanged: (val) {
          selectedSchool = val;
          selectedClass = null;
          selectedsection = null;
          selectedRefGroup = null;
          FeedbackController.loadinitials(ref, 'feed-classes', {
            'index': widget.index,
            'school': selectedSchool,
            'session': selectedSession,
            'id': widget.userId,
            'year': selectedYear
          });
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedClass,
        items: ref
            .watch(FeedbackController.classes)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Class',
            prefixIcon: Icon(TablerIcons.chalkboard, color: Colors.grey)),
        onChanged: (val) {
          selectedClass = val;
          selectedsection = null;
          selectedRefGroup = null;
          FeedbackController.loadinitials(ref, 'feed-secs', {
            'index': widget.index,
            'school': selectedSchool,
            'className': selectedClass,
            'session': selectedSession,
            'id': widget.userId,
            'year': selectedYear
          });
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedsection,
        items: ref
            .watch(FeedbackController.sections)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Section',
            prefixIcon: Icon(Icons.book, color: Colors.grey)),
        onChanged: (val) {
          selectedsection = val;
          selectedRefGroup = null;
          FeedbackController.loadinitials(ref, 'feed-refs', {
            'index': widget.index,
            'school': selectedSchool,
            'className': selectedClass,
            'session': selectedSession,
            'sec': selectedsection,
            'id': widget.userId,
            'year': selectedYear
          });
        },
      ),
      DropdownButtonFormField<int>(
        value: selectedRefGroup,
        items: ref
            .watch(FeedbackController.refGroups)
            .map((e) => DropdownMenuItem<int>(
                value: e['id'] ?? '',
                child: Text(e['refgroup_name'] ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Ref group',
            prefixIcon: Icon(Icons.group, color: Colors.grey)),
        onChanged: (val) {
          selectedRefGroup = val;
        },
      ),
      Builder(builder: (context) {
        bool searching = ref.watch(FeedbackController.searching);
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
      appBar: AppBar(title: Text('feedback View')),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: [
            if (ref.watch(FeedbackController.years).isNotEmpty)
              AppController.animatedTitle(
                  '${widget.index == 0 ? 'CBSE' : "Matric"} School', isDark),
            SizedBox(height: 10),
            if (widget.feedback == null)
              if (ref.watch(FeedbackController.years).isNotEmpty)
                Form(
                  key: formKey,
                  child: ExpansionTileItem.outlined(
                    expansionKey: cardKey,
                    title: AppController.heading(
                        'Search', isDark, TablerIcons.search),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.yellow.withAlpha(60),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.person_4_rounded, size: 25),
                          title: Text('Search as a Staff!'),
                          trailing: Switch(
                            value: isStaff,
                            onChanged: (val) {
                              ref
                                  .read(FeedbackController.isStaff.notifier)
                                  .state = val;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
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
            if (ref.watch(FeedbackController.years).isNotEmpty ||
                ref.watch(FeedbackController.feedAvail))
              listener == null
                  ? InitializerWidget()
                  : listener.when(
                      data: (snap) {
                        return DefaultTabController(
                          length: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppController.heading(
                                  'Student FeedBack ( General ) / $selectedSchool / $selectedClass / $selectedsection / ${snap.data.feedbackStudents.isEmpty ? "Feedback is not available!" : ""}',
                                  isDark,
                                  Icons.feedback),
                              SizedBox(height: 10),
                              TabBar(
                                labelStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                labelColor: AppController.headColor,
                                indicatorColor: AppController.darkGreen,
                                dividerColor: Colors.grey.withAlpha(30),
                                tabs: [
                                  Tab(text: 'Feedback Score'),
                                  Tab(text: 'Optional Feedback'),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.7,
                                child: TabBarView(
                                  children: [
                                    FeedbackDetails(snap: snap, isDark: isDark),
                                    OptionalFeedback(isDark: isDark, snap: snap)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      error: (e, _) => CommonErrorWidget(),
                      loading: () => TableShimmer(isDark: isDark),
                    ),
          ],
        ),
      ),
    );
  }
}
