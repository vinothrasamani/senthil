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
import 'package:senthil/widgets/my_chip.dart';

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
          controller.setData(ref, 'handling-schools', {'type': val});
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
          controller.setData(
              ref, 'handling-classes', {'school': val, 'type': selectedType});
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
          controller.setData(ref, 'handling-sections',
              {'school': selectedSchool, 'type': selectedType, 'cName': val});
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
                      ? SizedBox(
                          height: 200,
                          child: Center(
                              child:
                                  Text('Search to Get subject handling list!')),
                        )
                      : Column(
                          children: [
                            AppController.heading(
                                'Subject Handling', isDark, TablerIcons.book_2),
                            SizedBox(height: 10),
                            for (var item in snap)
                              Builder(builder: (context) {
                                final index = snap.indexOf(item) + 1;
                                return myCard(item, index);
                              }),
                          ],
                        ),
          ],
        ),
      ),
    );
  }

  Widget myCard(HandlingSubject item, int index) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withAlpha(100), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 6,
                          backgroundColor: AppController.darkGreen,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(item.staffName,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    MyChip(item.code, AppController.lightBlue),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  ref.read(subjectHandlingProvider.notifier).onDelete(item.id);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    AppController.red.withAlpha(20),
                  ),
                ),
                icon: Icon(TablerIcons.trash, color: AppController.red),
              ),
            ],
          ),
          myRow('Class', '${item.classname},'),
          myRow('Section', '${item.secname},'),
          myRow('Department', '${item.department},'),
          myRow('Subject', item.fullname),
        ],
      ),
    );
  }

  Widget myRow(String myKey, String val) {
    return Text.rich(
      TextSpan(
        text: '$myKey ',
        style: TextStyle(color: Colors.grey),
        children: [
          TextSpan(
            text: ': $val',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
