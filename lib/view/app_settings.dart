import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/settings_controller.dart';
import 'package:senthil/controller/theme_controller.dart';

class AppSettings extends ConsumerWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget title(String text) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 10),
            title('Theme'),
            Builder(builder: (context) {
              bool isDark =
                  ref.watch(ThemeController.themeMode) == ThemeMode.dark;
              return SwitchListTile(
                thumbIcon: WidgetStatePropertyAll(
                    Icon(isDark ? Icons.light_mode : Icons.dark_mode)),
                title: Row(
                  children: [
                    Icon(TablerIcons.brightness),
                    SizedBox(width: 10),
                    Text('Dark Theme'),
                  ],
                ),
                value: isDark,
                onChanged: (val) => SettingsController.changeTheme(ref, val),
              );
            }),
            SizedBox(height: 10),
            title('Aditionals'),
            ListTile(
              leading: Icon(Icons.settings_suggest),
              title: Text('Additional Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(TablerIcons.logout),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => SettingsController.logout(ref),
            ),
          ],
        ),
      ),
    );
  }
}
