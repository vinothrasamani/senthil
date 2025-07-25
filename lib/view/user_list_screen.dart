import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/controller/user_list_controller.dart';
import 'package:senthil/model/user_list_model.dart';
import 'package:senthil/shimmer/user_list_shimmer.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  bool initial = true;
  Widget leading = Container(
    padding: EdgeInsets.all(2),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
  );

  Widget userCard(UserList user) => Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppController.lightBlue.withAlpha(60)),
                child: Icon(Icons.person, color: AppController.lightBlue),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              title: Text(
                user.name.trim(),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              subtitle: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                    decoration: BoxDecoration(
                      color: baseColor.withAlpha(50),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.fullname ?? '🤷‍♀️',
                      style: TextStyle(
                          color: baseColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              trailing: user.mobile == null
                  ? null
                  : Icon(TablerIcons.phone, color: AppController.darkGreen),
            ),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                Chip(
                  label: Text(user.school),
                  avatar: Icon(
                    TablerIcons.school,
                    color: AppController.headColor,
                  ),
                ),
                if (user.board != null)
                  Chip(
                    label: Text(user.board!),
                    avatar: Icon(
                      TablerIcons.dashboard,
                      color: AppController.red,
                    ),
                  ),
                if (user.className != null)
                  Tooltip(
                    message: user.className!,
                    triggerMode: TooltipTriggerMode.tap,
                    child: Chip(
                      label: Text(user.className!),
                      avatar: Icon(
                        TablerIcons.chalkboard,
                        color: AppController.yellow,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: SafeArea(
        child: ref.watch(UserListController.getUsers).when(
              data: (snap) {
                List filtered = ref.watch(UserListController.filteredUsers);
                if (initial) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref.read(UserListController.filteredUsers.notifier).state =
                        snap;
                  });
                  initial = false;
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                        ),
                        onChanged: (v) {
                          UserListController.filter(v, ref, snap);
                        },
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: filtered.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.filter_list_off, size: 30),
                                    SizedBox(height: 10),
                                    Text('User List Empty!'),
                                  ],
                                ),
                              )
                            : ListView(
                                children: [
                                  for (var user in filtered) userCard(user),
                                ],
                              ),
                      ),
                    ],
                  ),
                );
              },
              error: (error, _) => Container(
                height: size.height * 0.8,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 30),
                    SizedBox(height: 10),
                    Text('Something went wrong!'),
                  ],
                ),
              ),
              loading: () => UserListShimmer(isDark: isDark),
            ),
      ),
    );
  }
}
