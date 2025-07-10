import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/staff_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/shimmer/search_shimmer.dart';

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
  String? selectedSchool, selectedCategory, selectedDepartment;
  String? staffCode, staffName;
  Object? data;

  @override
  void initState() {
    StaffController.setData(ref, 'staff-schools', {'id': widget.userId});
    super.initState();
  }

  void search() async {
    ref.read(StaffController.searching.notifier).state = true;
    data = {
      "index": widget.index,
      "school": selectedSchool,
      "cat": selectedCategory,
      "code": staffCode,
      "name": staffName,
      "dept": selectedDepartment
    };
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    Size size = MediaQuery.of(context).size;

    final listener =
        data == null ? null : ref.watch(StaffController.staffDetails(data!));

    List<Widget> dropdownList = [
      DropdownButtonFormField<String>(
        value: selectedSchool,
        items: ref
            .watch(StaffController.schools)
            .map((e) => DropdownMenuItem<String>(
                value: e ?? '', child: Text(e ?? 'None')))
            .toList(),
        decoration: InputDecoration(
            labelText: 'School', prefixIcon: Icon(Icons.school)),
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
            labelText: 'Category', prefixIcon: Icon(Icons.category)),
        onChanged: (val) {
          selectedCategory = val;
          selectedDepartment = null;
          StaffController.setData(ref, 'staff-categories',
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
            labelText: 'Department', prefixIcon: Icon(Icons.class_)),
        onChanged: (val) {
          selectedDepartment = val;
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Staff Details')),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: [
            if (ref.watch(StaffController.schools).isNotEmpty)
              AppController.animatedTitle(
                  '${widget.index == 0 ? 'CBSE' : "Metric"} School', isDark),
            SizedBox(height: 10),
            if (ref.watch(StaffController.schools).isNotEmpty)
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
                                    : size.width < 1020
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
              SearchShimmer(isDark: isDark),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
