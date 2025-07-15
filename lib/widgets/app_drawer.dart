import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/login_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/view/app_settings.dart';
import 'package:senthil/view/comparison_screen.dart';
import 'package:senthil/view/consistency_screen.dart';
import 'package:senthil/view/exam_upload_details_screen.dart';
import 'package:senthil/view/feedback_screen.dart';
import 'package:senthil/view/notice_screen.dart';
import 'package:senthil/view/question_screen.dart';
import 'package:senthil/view/staff_details/staff_details_screen.dart';
import 'package:senthil/view/topper_list_image_screen.dart';
import 'package:senthil/view/topper_list_screen.dart';
import 'package:senthil/view/web_view_screen.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(LoginController.userProvider);
    final isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;
    final schools = ['Public School', 'Matric School'];
    final menuItems = [
      'Comparison',
      'Topper List',
      'Topper List Image',
      'Consistency',
      'Question & M.Scheme',
      'Feedback View',
      'Staff Details',
      'Exam Upload Details'
    ];
    final menuIcons = [
      Icons.compare,
      Icons.view_list,
      Icons.image,
      Icons.person,
      Icons.question_mark,
      Icons.feedback,
      Icons.person_3_rounded,
      Icons.question_answer
    ];

    Widget menuItem(IconData icon, String title, Widget screen) {
      return ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () {
          Get.back();
          Get.to(() => screen, transition: Transition.zoom);
        },
      );
    }

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
          for (var school in schools)
            Builder(builder: (context) {
              final schoolIndex = schools.indexOf(school);
              return ExpansionTile(
                leading: Text(school[0].toUpperCase(),
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        color: isDark ? Colors.blue : baseColor,
                        fontWeight: FontWeight.bold)),
                textColor: AppController.headColor,
                title: Text(school),
                children: [
                  for (var item in menuItems)
                    Builder(builder: (context) {
                      final index = menuItems.indexOf(item);
                      return ListTile(
                        leading: Icon(menuIcons[index]),
                        title: Text(item),
                        onTap: () {
                          Get.back();
                          switch (index) {
                            case 0:
                              Get.to(
                                  () => ComparisonScreen(
                                      index: schoolIndex, userId: user.data.id),
                                  transition: Transition.zoom);
                              break;
                            case 1:
                              Get.to(
                                  () => TopperListScreen(
                                      index: schoolIndex, userId: user.data.id),
                                  transition: Transition.zoom);
                              break;
                            case 2:
                              Get.to(
                                  () => TopperListImageScreen(
                                      index: schoolIndex, userId: user.data.id),
                                  transition: Transition.zoom);
                              break;
                            case 3:
                              Get.to(
                                  () => ConsistencyScreen(
                                      index: schoolIndex, userId: user.data.id),
                                  transition: Transition.zoom);
                              break;
                            case 4:
                              Get.to(
                                  () => QuestionScreen(
                                      index: schoolIndex, userId: user.data.id),
                                  transition: Transition.zoom);
                              break;
                            case 5:
                              Get.to(
                                  () => FeedbackScreen(
                                      index: schoolIndex, userId: user.data.id),
                                  transition: Transition.zoom);
                              break;
                            case 6:
                              Get.to(
                                  () => StaffDetailsScreen(
                                      index: schoolIndex, userId: user.data.id),
                                  transition: Transition.zoom);
                              break;
                            case 7:
                              Get.to(
                                  () => ExamUploadDetailsScreen(
                                      index: schoolIndex),
                                  transition: Transition.zoom);
                              break;
                            default:
                          }
                        },
                      );
                    }),
                ],
              );
            }),
          ExpansionTile(
            leading: Icon(Icons.admin_panel_settings_outlined),
            title: Text('Additional'),
            textColor: AppController.headColor,
            children: [
              menuItem(TablerIcons.message, 'Notice', NoticeScreen()),
            ],
          ),
          ListTile(
            leading: Icon(TablerIcons.settings),
            title: Text('Settings'),
            onTap: () {
              Get.back();
              Get.to(() => AppSettings());
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Privacy Policy'),
            onTap: () {
              Get.back();
              Get.to(() => WebViewScreen(
                    link: 'https://google.com',
                  ));
            },
          ),
        ],
      ),
    );
  }
}
