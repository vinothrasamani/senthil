import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/notice_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/shimmer/notice_shimmer.dart';

class NoticeScreen extends ConsumerStatefulWidget {
  const NoticeScreen({super.key});

  @override
  ConsumerState<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends ConsumerState<NoticeScreen> {
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final person = TextEditingController();
  final message = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    person.dispose();
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listener = ref.watch(NoticeController.noticeData(1));
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    bool isMessage = ref.watch(NoticeController.message);
    bool isBanner = ref.watch(NoticeController.banner);
    bool isDashboard = ref.watch(NoticeController.dashboard);

    Widget input(String name, IconData icon,
        {Function(String?)? onchanged, TextEditingController? controller}) {
      return TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: name,
          hintText: 'Enter $name',
          prefixIcon: Icon(icon, color: Colors.grey),
        ),
        validator: (value) => value == null ? 'Please enter $name' : null,
        onChanged: onchanged,
        maxLines: 10,
        minLines: 1,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Notice')),
      body: SafeArea(
        child: listener.when(
          data: (snap) {
            person.text = snap.noticeby;
            title.text = snap.noticetitle;
            message.text = snap.noticetext;
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(15),
              children: [
                AppController.heading(
                    'Notice Control', isDark, TablerIcons.message_2),
                SizedBox(height: 10),
                SwitchListTile(
                  value: isMessage,
                  title: Text('Show Message'),
                  onChanged: (v) {
                    ref.read(NoticeController.message.notifier).state = v;
                  },
                ),
                SwitchListTile(
                  value: isBanner,
                  title: Text('Show Banner'),
                  onChanged: (v) {
                    ref.read(NoticeController.banner.notifier).state = v;
                  },
                ),
                SwitchListTile(
                  value: isDashboard,
                  title: Text('Show Dashboard'),
                  onChanged: (v) {
                    ref.read(NoticeController.dashboard.notifier).state = v;
                  },
                ),
                SizedBox(height: 20),
                AppController.heading(
                    'Notice info', isDark, TablerIcons.message_2_up),
                SizedBox(height: 10),
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      input('Person', TablerIcons.user, onchanged: (v) {
                        person.text = v!;
                        snap.noticeby = v;
                      }, controller: person),
                      SizedBox(height: 10),
                      input('Title', TablerIcons.heading, onchanged: (v) {
                        title.text = v!;
                        snap.noticetitle = v;
                      }, controller: title),
                      SizedBox(height: 10),
                      input('Message', TablerIcons.message_2, onchanged: (v) {
                        message.text = v!;
                        snap.noticetext = v;
                      }, controller: message),
                    ],
                  ),
                ),
              ],
            );
          },
          error: (error, _) {
            return Center(child: Text('Something went wrong'));
          },
          loading: () => NoticeShimmer(isDark: isDark),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        child: Builder(builder: (context) {
          bool updating = ref.watch(NoticeController.updating);
          return FilledButton(
            onPressed: updating
                ? null
                : () {
                    NoticeController.update(ref, {
                      'id': 1,
                      'noticeby': person.text,
                      'noticetitle': title.text,
                      'noticetext': message.text,
                      'ismessage': isMessage ? 1 : 0,
                      'isbanner': isBanner ? 1 : 0,
                      'isdashboard': isDashboard ? 1 : 0,
                    });
                  },
            child: Text(updating ? 'Updating..' : 'Update'),
          );
        }),
      ),
    );
  }
}
