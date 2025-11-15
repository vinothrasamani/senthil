import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/staff_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/shimmer/search_shimmer.dart';
import 'package:senthil/shimmer/staff_screen_shimmer.dart';
import 'package:senthil/widgets/staff_details/downloaded_pdfs.dart';
import 'package:senthil/widgets/staff_details/staff_detail_card.dart';

class StaffDetailsScreen extends ConsumerStatefulWidget {
  const StaffDetailsScreen(
      {super.key, required this.index, required this.userId});
  final int index;
  final int userId;

  @override
  ConsumerState<StaffDetailsScreen> createState() => _StaffDetailsScreenState();
}

class _StaffDetailsScreenState extends ConsumerState<StaffDetailsScreen> {
  final formKey = GlobalKey<FormState>();
  final cardKey = GlobalKey<ExpansionTileCoreState>();
  ScrollController scrollController = ScrollController();
  String? selectedSchool, selectedCategory, selectedDepartment;
  String? staffCode, staffName;
  Object? data;

  @override
  void initState() {
    StaffController.setData(ref, 'staff-schools', {'id': widget.userId});
    super.initState();
  }

  void search() async {
    if (selectedSchool != null) {
      ref.read(StaffController.searching.notifier).state = true;
      data = {
        "index": widget.index,
        "school": selectedSchool,
        "cat": selectedCategory,
        "code": staffCode,
        "name": staffName,
        "dept": selectedDepartment
      };
    } else {
      AppController.toastMessage('Required!', 'Please select school');
    }
    cardKey.currentState?.collapse();
  }

  void openDownloads() async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      builder: (ctx) => DownloadedPdfs(),
    );
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

    final listener =
        data == null ? null : ref.watch(StaffController.staffDetails(data!));

    List<Widget> staffList(snap) {
      return [
        for (var i = 0; i < snap.data.length; i++)
          Builder(
            builder: (context) {
              final staff = snap.data[i];
              return StaffDetailCard(staff: staff, isDark: isDark);
            },
          ),
      ];
    }

    List<Widget> dropdownList = [
      DropdownButtonFormField<String>(
        value: selectedSchool,
        items: ref
            .watch(StaffController.schools)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'School',
            prefixIcon: Icon(
              TablerIcons.school,
              color: Colors.grey,
            )),
        onChanged: (val) {
          selectedSchool = val;
          selectedCategory = null;
          selectedDepartment = null;
          StaffController.setData(
              ref, 'staff-categories', {'index': widget.index, 'school': val});
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedCategory,
        items: ref
            .watch(StaffController.categories)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Category',
            prefixIcon: Icon(
              TablerIcons.category,
              color: Colors.grey,
            )),
        onChanged: (val) {
          selectedCategory = val;
          selectedDepartment = null;
          StaffController.setData(ref, 'staff-dept',
              {'index': widget.index, 'school': selectedSchool, 'cat': val});
        },
      ),
      DropdownButtonFormField<String>(
        value: selectedDepartment,
        items: ref
            .watch(StaffController.departments)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'Department',
            prefixIcon: Icon(
              TablerIcons.building_store,
              color: Colors.grey,
            )),
        onChanged: (val) {
          selectedDepartment = val;
        },
      ),
      TextField(
        decoration: InputDecoration(
            labelText: 'Staff Code',
            prefixIcon: Icon(
              TablerIcons.message_code,
              color: Colors.grey,
            )),
        onChanged: (val) {
          staffCode = val;
        },
      ),
      TextField(
        decoration: InputDecoration(
            labelText: 'Staff Name',
            prefixIcon: Icon(
              TablerIcons.user,
              color: Colors.grey,
            )),
        onChanged: (val) {
          staffName = val;
        },
      ),
      Builder(builder: (context) {
        bool searching = ref.watch(StaffController.searching);
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
        title: Text('Staff Details'),
        actions: [
          if (!kIsWeb)
            IconButton(
              onPressed: openDownloads,
              icon: Icon(TablerIcons.download),
            ),
          IconButton(
            onPressed: () {
              scrollController.animateTo(5,
                  duration: Duration(seconds: 1), curve: Curves.easeInOut);
              cardKey.currentState?.expand();
            },
            icon: Icon(TablerIcons.search),
          ),
          SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          controller: scrollController,
          padding: EdgeInsets.all(10),
          children: [
            if (ref.watch(StaffController.schools).isNotEmpty)
              AppController.animatedTitle(
                  '${widget.index == 0 ? 'CBSE' : "Metric"} School', isDark),
            SizedBox(height: 10),
            if (ref.watch(StaffController.schools).isNotEmpty)
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
            if (ref.watch(StaffController.schools).isNotEmpty)
              listener == null
                  ? SizedBox(
                      height: 200,
                      child: Center(child: Text('Search to get staff List!')),
                    )
                  : listener.when(
                      data: (snap) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppController.heading(
                                'Staff List', isDark, TablerIcons.list),
                            SizedBox(height: 10),
                            if (snap.data.isNotEmpty)
                              if (size.width > 800)
                                Wrap(
                                  spacing: 5,
                                  children: [
                                    ...staffList(snap).map((c) {
                                      return SizedBox(
                                        width: (size.width / 2) - 30,
                                        child: c,
                                      );
                                    }),
                                  ],
                                )
                              else
                                ...staffList(snap),
                          ],
                        );
                      },
                      error: (e, _) => SizedBox(
                        height: 200,
                        child: Center(child: Text('Something went wrong! $e')),
                      ),
                      loading: () => StaffScreenShimmer(isDark: isDark),
                    )
          ],
        ),
      ),
    );
  }
}
