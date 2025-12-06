import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/consistency_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/shimmer/consistency_shimmer.dart';
import 'package:senthil/shimmer/search_shimmer.dart';
import 'package:senthil/widgets/common_error_widget.dart';
import 'package:senthil/widgets/consistency_table.dart';
import 'package:senthil/widgets/initializer_widget.dart';

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
  String? selectedYear, selectedClass, selectedCourse;
  Object? data;
  final cardKey = GlobalKey<ExpansionTileCoreState>();

  @override
  void initState() {
    ConsistencyController.setConData(
        ref, 'years', {'index': widget.index, 'id': widget.userId});
    super.initState();
  }

  void search() async {
    ref.read(ConsistencyController.searchingTop.notifier).state = true;
    data = {
      'userId': widget.userId,
      "index": widget.index,
      "course": selectedCourse,
      "year": selectedYear,
      "className": selectedClass
    };
    cardKey.currentState?.collapse();
  }

  Widget desc(bool isDark) => Row(
        children: [
          Chip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Admission No. :'),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: isDark ? AppController.lightBlue : baseColor),
                      borderRadius: BorderRadius.circular(5)),
                  child: const Text(
                    '123456',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Chip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Section : '),
                const SizedBox(width: 8),
                Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppController.darkGreen),
                  child: const Text(
                    'A',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

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
            labelText: 'Academic Year',
            prefixIcon: Icon(
              TablerIcons.calendar_smile,
              color: Colors.grey,
            )),
        onChanged: (val) {
          setState(() {
            selectedYear = val;
            selectedClass = null;
            selectedCourse = null;
          });
          ConsistencyController.setConData(ref, 'classes', {
            'index': widget.index,
            'year': selectedYear,
            'userId': widget.userId
          });
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
          setState(() {
            selectedClass = val;
            selectedCourse = null;
          });
          ConsistencyController.setConData(ref, 'con-courses', {
            'index': widget.index,
            'className': val,
            'year': selectedYear,
            'userId': widget.userId
          });
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedCourse,
        items: ref
            .watch(ConsistencyController.conCourses)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Main Course',
            prefixIcon: Icon(Icons.golf_course, color: Colors.grey)),
        onChanged: (val) {
          setState(() {
            selectedCourse = val;
          });
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
      appBar: AppBar(title: const Text('Consistency')),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          children: [
            if (ref.watch(ConsistencyController.conYears).isNotEmpty)
              AppController.animatedTitle(
                  '${widget.index == 0 ? 'CBSE' : "Matric"} School', isDark),
            const SizedBox(height: 10),
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
            const SizedBox(height: 20),
            if (ref.watch(ConsistencyController.conYears).isNotEmpty)
              listener == null
                  ? const InitializerWidget()
                  : listener.when(
                      data: (snap) {
                        Widget commonText(String school) => Text.rich(
                              TextSpan(
                                text: 'Consistency Results of class ',
                                children: [
                                  TextSpan(
                                    text:
                                        '$selectedClass ($school School) $selectedYear',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 34, 139, 34)),
                                  ),
                                ],
                              ),
                            );

                        return DefaultTabController(
                          length: snap.schools.length,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TabBar(
                                isScrollable:
                                    snap.schools.length > 4 ? true : false,
                                tabAlignment: snap.schools.length > 4
                                    ? TabAlignment.start
                                    : null,
                                labelStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                labelColor: AppController.headColor,
                                indicatorColor: AppController.darkGreen,
                                dividerColor: Colors.grey.withAlpha(30),
                                tabs: [
                                  for (var item in snap.schools)
                                    Tab(text: item.short),
                                ],
                              ),
                              SizedBox(
                                height: size.height,
                                child: TabBarView(
                                  children: [
                                    for (var item in snap.schools)
                                      Builder(builder: (context) {
                                        bool isLargeScreen = size.width > 800;
                                        final schoolIndex =
                                            snap.schools.indexOf(item);
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            AppController.heading(
                                                'Exam Result Student Consistency',
                                                isDark,
                                                TablerIcons.chart_donut),
                                            const SizedBox(height: 10),
                                            commonText(item.short),
                                            const SizedBox(height: 10),
                                            if (!isLargeScreen) desc(isDark),
                                            const SizedBox(height: 10),
                                            ConsistencyTable(
                                                snap: snap,
                                                isDark: isDark,
                                                schoolIndex: schoolIndex)
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
                      error: (e, _) {
                        debugPrint('$e');
                        return const CommonErrorWidget();
                      },
                      loading: () => ConsistencyShimmer(isDark: isDark),
                    ),
          ],
        ),
      ),
    );
  }
}
