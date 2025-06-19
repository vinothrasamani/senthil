import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:senthil/controller/login_controller.dart';
import 'package:senthil/view/app_settings.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(LoginController.userProvider);

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hi, ${user!.data.fullname}',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                SizedBox(
                  width: 60,
                  height: 50,
                  child:
                      Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                ),
                SizedBox(height: 5),
                Text('Senthil Group Of Schools',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text('Salem / Dharmapuri /Krishnagiri',
                    style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(TablerIcons.settings),
            title: Text('Settings'),
            onTap: () {
              Get.back();
              Get.to(() => AppSettings());
            },
          ),
        ],
      ),
    );
  }
}
