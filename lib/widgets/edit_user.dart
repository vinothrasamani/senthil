import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/controller/user_list_controller.dart';
import 'package:senthil/model/user_list_model.dart';

class EditUser extends ConsumerStatefulWidget {
  const EditUser({super.key, required this.user});
  final UserList user;

  @override
  ConsumerState<EditUser> createState() => _EditUserState();
}

class _EditUserState extends ConsumerState<EditUser> {
  final formKey = GlobalKey<FormState>();

  void submit() async {
    if (formKey.currentState!.validate()) {
      ref.read(UserListController.updating.notifier).state = true;
      final user = widget.user;
      final data = {
        'id': user.id,
        'name': user.name,
        'className': ref.read(UserListController.selectedStds).join(','),
        'board': ref.read(UserListController.selectedBoards).join(','),
        'school': ref.read(UserListController.selectedSchools).join(','),
        'ref': user.refName,
        'fullname': user.fullname,
        'mobile': user.mobile,
      };
      await UserListController.update(data);
      ref.read(UserListController.updating.notifier).state = false;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) {
      ref.read(UserListController.selectedSchools.notifier).state =
          widget.user.school.split(',');
      if (widget.user.board != null) {
        ref.read(UserListController.selectedBoards.notifier).state =
            widget.user.board!.split(',');
      }
      if (widget.user.className != null) {
        ref.read(UserListController.selectedStds.notifier).state =
            widget.user.className!.split(',');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final schools = ref.watch(UserListController.selectedSchools);
    final boards = ref.watch(UserListController.selectedBoards);
    final standards = ref.watch(UserListController.selectedStds);
    final Size size = MediaQuery.of(context).size;
    final isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;

    Widget leading(IconData icon) {
      return Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
          color: baseColor.withAlpha(40),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: EdgeInsets.all(10),
        child: Icon(icon, size: 26),
      );
    }

    var pad = size.width > 500
        ? size.width > 800
            ? size.width > 1000
                ? size.width * 0.20
                : size.width * 0.16
            : size.width * 0.12
        : 2.0;

    return Scaffold(
      appBar: AppBar(title: Text('Edit ${widget.user.fullname}')),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: pad),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              if (size.width > 500)
                BoxShadow(
                  offset: Offset(0, 0.5),
                  color: Colors.grey.withAlpha(160),
                  spreadRadius: 1,
                  blurRadius: 2,
                ),
            ],
          ),
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(15),
              shrinkWrap: true,
              children: [
                AppController.heading('Basic Info', isDark, Icons.info_outline),
                SizedBox(height: 6),
                TextFormField(
                  initialValue: widget.user.fullname,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    icon: leading(TablerIcons.user),
                  ),
                  onChanged: (value) => widget.user.fullname = value,
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: widget.user.mobile,
                  decoration: InputDecoration(
                    labelText: 'Mobile No.',
                    icon: leading(TablerIcons.phone),
                  ),
                  onChanged: (value) => widget.user.mobile = value,
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: widget.user.name,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    icon: leading(TablerIcons.user),
                  ),
                  onChanged: (value) => widget.user.name = value,
                  validator: (value) => value == null || value.isEmpty
                      ? 'This is required!'
                      : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: widget.user.refName,
                  decoration: InputDecoration(
                    labelText: 'Ref Name',
                    icon: leading(TablerIcons.user_pin),
                  ),
                  onChanged: (value) => widget.user.refName = value,
                ),
                SizedBox(height: 30),
                AppController.heading('Choose School(s)', isDark, Icons.school),
                SizedBox(height: 6),
                DropdownButtonFormField(
                  items: UserListController.schools
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'School',
                    prefixIcon: Icon(
                      TablerIcons.school,
                      color: Colors.grey,
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'This is required!'
                      : null,
                  onChanged: (val) {
                    if (!schools.contains(val)) {
                      ref
                          .read(UserListController.selectedSchools.notifier)
                          .state = [...schools, val!];
                    }
                  },
                ),
                SizedBox(height: 5),
                Wrap(
                    spacing: 5,
                    children: schools
                        .map((e) => Chip(
                              label: Text(e),
                              deleteIcon:
                                  Icon(Icons.cancel, color: AppController.red),
                              onDeleted: () {
                                ref
                                        .read(UserListController
                                            .selectedSchools.notifier)
                                        .state =
                                    schools.where((i) => i != e).toList();
                              },
                            ))
                        .toList()),
                SizedBox(height: 30),
                AppController.heading(
                    'Choose board(s)', isDark, TablerIcons.category),
                SizedBox(height: 6),
                DropdownButtonFormField(
                  items: UserListController.boards
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Board',
                    prefixIcon: Icon(TablerIcons.category, color: Colors.grey),
                  ),
                  onChanged: (val) {
                    if (!boards.contains(val)) {
                      ref
                          .read(UserListController.selectedBoards.notifier)
                          .state = [...boards, val!];
                    }
                  },
                ),
                SizedBox(height: 5),
                Wrap(
                    spacing: 5,
                    children: boards
                        .map((e) => Chip(
                              label: Text(e),
                              deleteIcon:
                                  Icon(Icons.cancel, color: AppController.red),
                              onDeleted: () {
                                ref
                                        .read(UserListController
                                            .selectedBoards.notifier)
                                        .state =
                                    boards.where((i) => i != e).toList();
                              },
                            ))
                        .toList()),
                SizedBox(height: 30),
                AppController.heading(
                    'Choose Standard(s)', isDark, Icons.class_),
                SizedBox(height: 6),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Standard',
                    prefixIcon:
                        Icon(TablerIcons.chalkboard, color: Colors.grey),
                  ),
                  items: UserListController.standards
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (!standards.contains(val)) {
                      ref.read(UserListController.selectedStds.notifier).state =
                          [...standards, val!];
                    }
                  },
                ),
                SizedBox(height: 5),
                Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: standards
                        .map((e) => Chip(
                              label: Text(e),
                              deleteIcon:
                                  Icon(Icons.cancel, color: AppController.red),
                              onDeleted: () {
                                ref
                                        .read(UserListController
                                            .selectedStds.notifier)
                                        .state =
                                    standards.where((i) => i != e).toList();
                              },
                            ))
                        .toList()),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: FilledButton(
                        onPressed: ref.watch(UserListController.updating)
                            ? null
                            : submit,
                        child: Text('Save'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
