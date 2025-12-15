import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/settings_controller.dart';
import 'package:senthil/model/login_model.dart';

class PopupMenu extends ConsumerWidget {
  const PopupMenu({super.key, required this.user});
  final LoginModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      itemBuilder: (ctx) => [
        PopupMenuItem(
          value: 1,
          child: ListTile(
            leading: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage('assets/images/placeholder.jpeg'),
            ),
            title: Text(
              user.data?.name ?? 'Username',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              user.data?.fullname ?? 'Fullname',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: ListTile(
            leading: Icon(
              TablerIcons.logout,
              color: AppController.red,
            ),
            onTap: () => SettingsController.logout(ref),
            title: Text('Logout'),
          ),
        ),
      ],
      child: CircleAvatar(
        backgroundColor: Colors.white30,
        backgroundImage: AssetImage('assets/images/placeholder.jpeg'),
      ),
    );
  }
}
