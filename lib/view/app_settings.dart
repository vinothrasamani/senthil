import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/settings_controller.dart';
import 'package:senthil/controller/theme_controller.dart';

class AppSettings extends ConsumerWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    final size = MediaQuery.of(context).size;
    bool can = size.width > 500;

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

    final rest = Padding(
      padding: const EdgeInsets.only(left: 35),
      child: Text(
        'Restricted by Admin!',
        style: TextStyle(
            fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );

    Widget content = Container(
      margin: EdgeInsets.symmetric(
          horizontal: can
              ? size.width > 900
                  ? size.width * 0.15
                  : size.width * 0.12
              : 0),
      padding: EdgeInsets.all(can ? 15 : 1),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          if (can)
            BoxShadow(
              offset: Offset(0, 1),
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 2,
            ),
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 10),
          title('App Settings'),
          Builder(builder: (context) {
            final bool canShowResult =
                ref.watch(SettingsController.canShowResult);
            final isBlocked = ref.watch(SettingsController.isResultBlocked);
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
              subtitle: isBlocked ? rest : null,
              value: isBlocked ? false : canShowResult,
              onChanged: isBlocked
                  ? null
                  : (val) {
                      ref
                          .read(SettingsController.canShowResult.notifier)
                          .state = val;
                      SettingsController.setResultAction(val);
                    },
            );
          }),
          Builder(builder: (context) {
            final bool canShowCollection =
                ref.watch(SettingsController.canShowCollection);
            final isBlocked = ref.watch(SettingsController.isCollectionBlocked);
            return SwitchListTile(
              thumbIcon: WidgetStatePropertyAll(
                Icon(canShowCollection ? Icons.slideshow : Icons.hide_source),
              ),
              subtitle: isBlocked ? rest : null,
              title: Row(
                children: [
                  Icon(TablerIcons.currency_dollar),
                  SizedBox(width: 10),
                  Expanded(child: Text('Enable Collection dashboard')),
                ],
              ),
              value: isBlocked ? false : canShowCollection,
              onChanged: isBlocked
                  ? null
                  : (val) {
                      ref
                          .read(SettingsController.canShowCollection.notifier)
                          .state = val;
                      SettingsController.setCollectionAction(val);
                    },
            );
          }),
          Builder(builder: (context) {
            final int currentAmt = ref.watch(SettingsController.defaultPayment);
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
          SizedBox(height: 20),
          title('Theme'),
          SwitchListTile(
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
          ),
          SizedBox(height: 20),
          if (!kIsWeb) ...[
            title('Additionals'),
            ListTile(
              leading: Icon(Icons.settings_suggest),
              title: Text('Additional Settings'),
              onTap: () => openAppSettings(),
            ),
          ],
          SizedBox(height: 20),
          if (can) logout(ref, isDark),
          SizedBox(height: 30),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SafeArea(child: can ? Center(child: content) : content),
      bottomNavigationBar: can
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                child: logout(ref, isDark),
              ),
            ),
    );
  }

  Widget logout(WidgetRef ref, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      constraints: BoxConstraints(maxWidth: 300),
      child: TextButton.icon(
        onPressed: () => SettingsController.logout(),
        style: TextButton.styleFrom(
          backgroundColor: AppController.red.withAlpha(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: AppController.red),
          ),
        ),
        icon: Icon(
          TablerIcons.logout,
          color: isDark ? Colors.white : AppController.red,
        ),
        label: Text(
          'Logout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppController.red,
          ),
        ),
      ),
    );
  }
}
