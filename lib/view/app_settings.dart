import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/settings_controller.dart';
import 'package:senthil/controller/theme_controller.dart';

class AppSettings extends ConsumerWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amounttitles = [
      'Target',
      'Concussion',
      'Net',
      'Paid',
      'Exclusion',
      'Balance'
    ];

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
            title('App Settings'),
            Builder(builder: (context) {
              final bool canShowResult =
                  ref.watch(SettingsController.canShowResult);
              return SwitchListTile(
                thumbIcon: WidgetStatePropertyAll(
                    Icon(canShowResult ? Icons.slideshow : Icons.hide_source)),
                title: Row(
                  children: [
                    Icon(TablerIcons.slideshow),
                    SizedBox(width: 10),
                    Expanded(child: Text('Enable examination result slider')),
                  ],
                ),
                value: canShowResult,
                onChanged: (val) {
                  ref.read(SettingsController.canShowResult.notifier).state =
                      val;
                  SettingsController.setResultAction(val);
                },
              );
            }),
            Builder(builder: (context) {
              final int currentAmt =
                  ref.watch(SettingsController.defaultPayment);
              return ListTile(
                leading: Icon(TablerIcons.moneybag),
                title: Text('Default payment type'),
                trailing: PopupMenuButton(
                  initialValue: currentAmt,
                  itemBuilder: (ctx) => amounttitles
                      .map(
                        (amt) => PopupMenuItem(
                          value: amounttitles.indexOf(amt),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                  radius: 5,
                                  backgroundColor: AppController.lightBlue),
                              SizedBox(width: 8),
                              Text(amt),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onSelected: (value) {
                    SettingsController.setPayType(value);
                    ref.read(SettingsController.defaultPayment.notifier).state =
                        value;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppController.lightGreen.withAlpha(50),
                      border: Border.all(
                          color: AppController.lightGreen.withAlpha(70)),
                    ),
                    child: Text(
                      amounttitles[currentAmt],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }),
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
