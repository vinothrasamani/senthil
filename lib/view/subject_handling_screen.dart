import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/subject_handling_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/subject_handling_model.dart';
import 'package:senthil/shimmer/list_shimmer.dart';
import 'package:senthil/shimmer/search_shimmer.dart';
import 'package:senthil/widgets/no_record_content.dart';

class SubjectHandlingScreen extends ConsumerStatefulWidget {
  const SubjectHandlingScreen({super.key, required this.id});
  final int id;

  @override
  ConsumerState<SubjectHandlingScreen> createState() =>
      _SubjectHandlingScreenState();
}

class _SubjectHandlingScreenState extends ConsumerState<SubjectHandlingScreen> {
  String? selectedType, selectedYear, selectedSchool;
  String? selectedSection, selectedClass, staffCode, staffName;
  bool isDark = false;
  final formKey = GlobalKey<FormState>();
  final controller = SubjectHandlingController();
  final cardKey = GlobalKey<ExpansionTileCoreState>();
  final scroll = ScrollController();

  @override
  void initState() {
    controller.setData(ref, 'initiate-handling', {'id': widget.id});
    super.initState();
  }

  void search() async {
    ref.read(controller.searching.notifier).state = true;
    final data = {
      "type": selectedType,
      "school": selectedSchool,
      "className": selectedClass ?? '',
      "year": selectedYear,
      "section": selectedSection ?? '',
      "name": staffName ?? '',
      "code": staffCode ?? '',
    };
    cardKey.currentState?.collapse();
    await ref.read(subjectHandlingProvider.notifier).fetchData(data);
    ref.read(controller.searching.notifier).state = false;
  }

  @override
  void dispose() {
    scroll.dispose();
    cardKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    Size size = MediaQuery.of(context).size;

    final snap = ref.watch(subjectHandlingProvider);

    List<Widget> dropdownList = [
      DropdownButtonFormField<String>(
        value: selectedYear,
        items: ref
            .watch(controller.years)
            .map((e) =>
                DropdownMenuItem<String>(value: e ?? '', child: Text(e ?? '')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Year',
            prefixIcon: Icon(
              TablerIcons.calendar_smile,
              color: Colors.grey,
            )),
        onChanged: (val) {
          selectedYear = val;
          selectedType = null;
          selectedClass = null;
          selectedSection = null;
          selectedSchool = null;
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedType,
        items: ref
            .watch(controller.schoolTypes)
            .map((e) =>
                DropdownMenuItem<String>(value: e ?? '', child: Text(e ?? '')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'School Type',
            prefixIcon: Icon(TablerIcons.category, color: Colors.grey)),
        onChanged: (val) {
          selectedType = val;
          selectedClass = null;
          selectedSection = null;
          selectedSchool = null;
          controller.setData(ref, 'handling-schools',
              {'type': val, 'id': widget.id, 'year': selectedYear});
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedSchool,
        items: ref
            .watch(controller.schools)
            .map((e) =>
                DropdownMenuItem<String>(value: e ?? '', child: Text(e ?? '')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'School',
            prefixIcon: Icon(TablerIcons.school, color: Colors.grey)),
        onChanged: (val) {
          selectedSchool = val;
          selectedClass = null;
          selectedSection = null;
          controller.setData(ref, 'handling-classes', {
            'school': val,
            'type': selectedType,
            'id': widget.id,
            'year': selectedYear
          });
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedClass,
        items: ref
            .watch(controller.classNames)
            .map((e) =>
                DropdownMenuItem<String>(value: e ?? '', child: Text(e ?? '')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Class Name',
            prefixIcon: Icon(TablerIcons.chalkboard, color: Colors.grey)),
        onChanged: (val) {
          selectedClass = val;
          selectedSection = null;
          controller.setData(ref, 'handling-sections', {
            'school': selectedSchool,
            'type': selectedType,
            'cName': val,
            'id': widget.id,
            'year': selectedYear
          });
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedSection,
        items: ref
            .watch(controller.sections)
            .map((e) =>
                DropdownMenuItem<String>(value: e ?? '', child: Text(e ?? '')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Section',
            prefixIcon: Icon(TablerIcons.category_plus, color: Colors.grey)),
        onChanged: (val) {
          selectedSection = val;
        },
      ),
      TextField(
        decoration: InputDecoration(labelText: 'Staff Code'),
        onChanged: (value) => staffCode = value,
      ),
      TextField(
        decoration: InputDecoration(labelText: 'Staff Name'),
        onChanged: (value) => staffName = value,
      ),
      Builder(builder: (context) {
        bool searching = ref.watch(controller.searching);
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
        title: Text('Subject Handling'),
        actions: [
          IconButton(
            onPressed: () {
              scroll.animateTo(0,
                  duration: Duration(seconds: 1), curve: Curves.easeIn);
              cardKey.currentState?.expand();
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          controller: scroll,
          padding: EdgeInsets.all(10),
          children: [
            if (ref.watch(controller.years).isNotEmpty)
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
            if (ref.watch(controller.years).isNotEmpty)
              ref.watch(controller.searching)
                  ? ListShimmer(isDark: isDark)
                  : snap.isEmpty
                      ? NoRecordContent(
                          msg: 'List is empty. Try new search to get data!')
                      : Column(
                          children: [
                            AppController.heading(
                                'Subject Handling', isDark, TablerIcons.book_2),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 5,
                              children: [
                                for (var item in snap)
                                  SizedBox(
                                    width: size.width > 700
                                        ? size.width > 1100
                                            ? (size.width / 3) - 30
                                            : (size.width / 2) - 30
                                        : null,
                                    child: Builder(builder: (context) {
                                      final index = snap.indexOf(item) + 1;
                                      return myCard(item, index);
                                    }),
                                  ),
                              ],
                            ),
                          ],
                        ),
          ],
        ),
      ),
    );
  }

  Widget myCard(HandlingSubject item, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color:
                isDark ? Colors.grey.withAlpha(80) : Colors.grey.withAlpha(40),
            width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 40 : 20),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppController.darkGreen,
                        AppController.darkGreen.withAlpha(180)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      item.staffName.isNotEmpty
                          ? item.staffName[0].toUpperCase()
                          : 'S',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.staffName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppController.lightBlue.withAlpha(25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.code,
                          style: TextStyle(
                            color: AppController.lightBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppController.red.withAlpha(15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () {
                      ref
                          .read(subjectHandlingProvider.notifier)
                          .onDelete(item.id);
                    },
                    constraints: BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      TablerIcons.trash,
                      color: AppController.red,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.withAlpha(100),
                  Colors.grey.withAlpha(100),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _detailRow('Class', item.classname),
                SizedBox(height: 5),
                _detailRow('Section', item.secname),
                SizedBox(height: 5),
                _detailRow('Department', item.department),
                SizedBox(height: 5),
                _detailRow('Subject', item.fullname),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.withAlpha(200),
              letterSpacing: 0.3,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
