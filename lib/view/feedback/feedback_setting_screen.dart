import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/feedback_list_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/notice_model.dart';
import 'package:senthil/shimmer/feedback_settings_shimmer.dart';

class FeedbackSettingScreen extends ConsumerStatefulWidget {
  const FeedbackSettingScreen({super.key});

  @override
  ConsumerState<FeedbackSettingScreen> createState() => _FeedbackSettingState();
}

class _FeedbackSettingState extends ConsumerState<FeedbackSettingScreen> {
  final name = TextEditingController();
  final titleMsg = TextEditingController();
  final message = TextEditingController();
  final dpicsc = TextEditingController();
  final dpimsc = TextEditingController();
  final kgicsc = TextEditingController();
  final slmcsc = TextEditingController();
  final kgimsc = TextEditingController();
  late NoticeData notice;
  String? selectedYear, selectedSession;

  Widget title(String val, IconData icon) => Padding(
        padding: const EdgeInsets.only(bottom: 5, top: 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            SizedBox(height: 15),
            Text(
              val,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  @override
  void initState() {
    loadFeedbackNotice();
    super.initState();
  }

  void loadFeedbackNotice() async {
    final years = await AppController.fetch('feed-notice-years');
    final decrypted = jsonDecode(years);
    if (decrypted['success']) {
      ref.read(FeedbackListController.years.notifier).state =
          decrypted['data']['years'];
      ref.read(FeedbackListController.sessions.notifier).state =
          decrypted['data']['sessions'];
    }
    final res = await AppController.fetch('feedback-settings');
    final data = noticeModelFromJson(res);
    if (data.success) {
      notice = data.data;
      name.text = notice.noticetitle;
      titleMsg.text = notice.noticeby;
      message.text = notice.noticetext;
      dpicsc.text = notice.dpicStaffcode;
      dpimsc.text = notice.dpimStaffcode;
      kgicsc.text = notice.kgicStaffcode;
      kgimsc.text = notice.kgimStaffcode;
      slmcsc.text = notice.slmStaffcode;
      selectedYear = notice.feedyear;
      selectedSession = notice.feedsession;
      ref.read(FeedbackListController.fStaff.notifier).state =
          notice.stafffeedback == 1;
      ref.read(FeedbackListController.fAnim.notifier).state =
          notice.animation == 1;
    }
    ref.read(FeedbackListController.feedLoading.notifier).state = false;
  }

  void update() async {
    ref.read(FeedbackListController.updating.notifier).state = true;
    final body = {
      'title': name.text,
      'noticetext': message.text,
      'noticeby': titleMsg.text,
      'slm_staffcode': slmcsc.text,
      'dpic_staffcode': dpicsc.text,
      'dpim_staffcode': dpimsc.text,
      'kgic_staffcode': kgicsc.text,
      'kgim_staffcode': kgimsc.text,
      'session': selectedSession,
      'year': selectedYear,
      'sFeed': ref.read(FeedbackListController.fStaff) ? 1 : 0,
      'anim': ref.read(FeedbackListController.fAnim) ? 1 : 0,
    };
    await FeedbackListController.updateNotice(body);
    ref.read(FeedbackListController.updating.notifier).state = false;
  }

  @override
  void dispose() {
    name.dispose();
    titleMsg.dispose();
    message.dispose();
    dpicsc.dispose();
    dpimsc.dispose();
    kgicsc.dispose();
    kgimsc.dispose();
    slmcsc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(FeedbackListController.feedLoading);
    final size = MediaQuery.of(context).size;
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    final years = ref.watch(FeedbackListController.years);
    final sessions = ref.watch(FeedbackListController.sessions);
    final updating = ref.watch(FeedbackListController.updating);
    final fa = ref.watch(FeedbackListController.fAnim);
    final fs = ref.watch(FeedbackListController.fStaff);

    var pad = size.width > 500
        ? size.width > 800
            ? size.width > 1000
                ? size.width * 0.20
                : size.width * 0.16
            : size.width * 0.12
        : 2.0;

    return Scaffold(
      appBar: AppBar(title: Text('Feedback Settings')),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: pad),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              if (size.width > 500)
                BoxShadow(
                  offset: Offset(0, 0.5),
                  color: Colors.grey.withAlpha(100),
                  spreadRadius: 1,
                  blurRadius: 2,
                ),
            ],
          ),
          child: isLoading
              ? FeedbackSettingsShimmer(isDark: isDark)
              : ListView(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shrinkWrap: true,
                  children: [
                    title('Person Name', TablerIcons.user),
                    TextField(
                      controller: name,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    title('Title Message', TablerIcons.message),
                    TextField(
                      controller: titleMsg,
                      decoration: InputDecoration(hintText: 'Title'),
                      minLines: 1,
                      maxLines: 2,
                    ),
                    title('Message', TablerIcons.message_2),
                    TextField(
                      controller: message,
                      decoration: InputDecoration(hintText: 'Message'),
                      minLines: 3,
                      maxLines: 6,
                    ),
                    title('Session', TablerIcons.timeline),
                    DropdownButtonFormField<String>(
                      value: selectedSession,
                      isDense: true,
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      items: sessions
                          .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      hint: Text('Session'),
                      onChanged: (s) {
                        selectedSession = s;
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        title('Year', TablerIcons.calendar),
                        SizedBox(width: 15),
                        Spacer(),
                        SizedBox(
                          width: 180,
                          child: DropdownButtonFormField<String>(
                            value: selectedYear,
                            isDense: true,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            items: years
                                .map<DropdownMenuItem<String>>((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            hint: Text('Year'),
                            onChanged: (year) {
                              selectedYear = year;
                            },
                          ),
                        ),
                      ],
                    ),
                    SwitchListTile(
                      value: fs,
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      onChanged: (value) {
                        ref.read(FeedbackListController.fStaff.notifier).state =
                            value;
                      },
                      title: title('Staff Feedback', Icons.feedback_outlined),
                    ),
                    SwitchListTile(
                      value: fa,
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      onChanged: (value) {
                        ref.read(FeedbackListController.fAnim.notifier).state =
                            value;
                      },
                      title: title('Feedback Admin', Icons.feedback_outlined),
                    ),
                    title('SLM-CBSC Staff Code', TablerIcons.user_code),
                    TextField(
                      controller: slmcsc,
                      decoration: InputDecoration(hintText: 'Staff code'),
                    ),
                    title('DPI-CBSC Staff Code', TablerIcons.user_code),
                    TextField(
                      controller: dpicsc,
                      decoration: InputDecoration(hintText: 'Staff code'),
                    ),
                    title('DPI-Metric Staff Code', TablerIcons.user_code),
                    TextField(
                      controller: dpimsc,
                      decoration: InputDecoration(hintText: 'Staff code'),
                    ),
                    title('KGI-CBSC Staff Code', TablerIcons.user_code),
                    TextField(
                      controller: kgicsc,
                      decoration: InputDecoration(hintText: 'Staff code'),
                    ),
                    title('KGI-Metric Staff Code', TablerIcons.user_code),
                    TextField(
                      controller: kgimsc,
                      decoration: InputDecoration(hintText: 'Staff code'),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: updating ? null : update,
                        child: Text('Update Notice'),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
        ),
      ),
    );
  }
}
