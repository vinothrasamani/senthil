import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/staff_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/model/staff_details_model.dart';
import 'package:senthil/widgets/staff_details/saved_pdf.dart';

class StaffInfoScreen extends ConsumerWidget {
  const StaffInfoScreen({super.key, required this.staff, required this.file});
  final StaffDetail staff;
  final String file;

  Widget title(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Text(text,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget image(double size, String url, {double pad = 0.0}) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.hardEdge,
        padding: EdgeInsets.all(pad),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.broken_image),
        ),
      );

  Widget value(String text, IconData icon) => ListTile(
        leading: Icon(icon, size: 25),
        dense: true,
        title: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = ref.watch(ThemeController.themeMode) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('About ${staff.staffName}'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Card(
              margin: EdgeInsets.all(6),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    image(50, '${AppController.baseImageUrl}/logo.png', pad: 2),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Senthil ${staff.schooltype == 'CBSE' ? 'Public' : 'Metric'} School',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '(${staff.school})',
                            style: TextStyle(
                                color: isDark
                                    ? AppController.lightBlue
                                    : baseColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      ref.read(StaffController.canExpand.notifier).state =
                          !ref.read(StaffController.canExpand);
                    },
                    child: ref.watch(StaffController.canExpand)
                        ? image(250,
                            '${AppController.baseStaffImageUrl}/${staff.code}.jpg')
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                AssetImage('assets/images/placeholder.jpeg'),
                            foregroundImage: NetworkImage(
                                '${AppController.baseStaffImageUrl}/${staff.code}.jpg'),
                          ),
                  ),
                  SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      staff.staffName ?? 'No name available!',
                      style: TextStyle(
                          fontSize: 18.5, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Divider(indent: 20, endIndent: 20),
            title('Name of the Staff'),
            value(staff.staffName ?? 'none!', TablerIcons.user),
            title('Staff Code'),
            value(staff.code ?? 'none!', TablerIcons.id_badge),
            title('Gender'),
            value(staff.gender ?? 'none!', TablerIcons.gender_agender),
            title('Designation'),
            value(staff.designation ?? 'none!', TablerIcons.medal),
            title('Qualification'),
            value(staff.qualification ?? 'none!', TablerIcons.school),
            title('Date of Birth'),
            value((staff.dob).toIso8601String().split('T')[0],
                TablerIcons.calendar_time),
            title('Blood Group'),
            value(staff.blood ?? 'none!', Icons.bloodtype),
            title('Social Category'),
            value('Religian : ${staff.religion ?? ''}', Icons.wb_sunny),
            value('Community : ${staff.community ?? ''}', Icons.group),
            value('Caste : ${staff.caste ?? ''}', TablerIcons.tree),
            title('Languages Known'),
            value(
                'To Speak : ${staff.toSpeak ?? ''}', TablerIcons.speakerphone),
            value('To Read : ${staff.toRead ?? ''}', Icons.read_more),
            value('To Write : ${staff.toWrite ?? ''}', TablerIcons.writing),
            title('Home Town'),
            value(staff.homeTown ?? 'none!', TablerIcons.building_community),
            title('Contact Number(s)'),
            value(staff.contact ?? 'none!', TablerIcons.phone),
            title('E-Mail Id'),
            value(staff.email ?? 'none!', TablerIcons.mail),
            title('Residental Address'),
            value(staff.address ?? 'none!', TablerIcons.address_book),
            title('Distance from School [In Km]'),
            value(staff.distance ?? 'none!', TablerIcons.map),
            title('Name of the Spouse/Parent'),
            value(staff.spouse ?? 'none!', Icons.person),
            title('Spouse/Parent Contact Number(s)'),
            value(staff.spContact ?? 'none!', TablerIcons.phone),
            title('Spouse/Parent Occupation'),
            value(staff.spOccup ?? 'none!', TablerIcons.badge),
            title('Children\'s Details (if Studying in SPS - Class & Sec)'),
            value(staff.children ?? 'none!', TablerIcons.users_group),
            title('Mode of Transport to the School'),
            value(staff.modeTrans ?? 'none!', TablerIcons.bus),
            title('Aadhar Number'),
            value(staff.aadhar ?? 'none!', TablerIcons.id),
            title('Pan Card Number'),
            value(staff.pan ?? 'none!', TablerIcons.id_badge_2),
            title('Bank Account Number'),
            value(staff.acc ?? 'none!', Icons.pin),
            title('Name of Bank & Branch'),
            value(staff.bank ?? 'none!', Icons.account_balance),
            title('IFSC Code'),
            value(staff.ifsc ?? 'none!', TablerIcons.code_dots),
            title('Date of Joining'),
            value((staff.doj).toIso8601String().split('T')[0],
                TablerIcons.calendar),
            title('Joined Category'),
            value(staff.catJoin ?? 'none!', TablerIcons.category_2),
            title('Present Category'),
            value(staff.catPres ?? 'none!', TablerIcons.category),
            title('Years of Experience (in SPS)'),
            value(staff.yeSchool ?? 'none!', TablerIcons.history),
            title('Years of Experience (overall)'),
            value(staff.yeOverall ?? 'none!', TablerIcons.history),
            title('Subject Handling'),
            value(
                staff.handSub == null || staff.handSub!.isEmpty
                    ? 'none!'
                    : staff.handSub!,
                TablerIcons.book),
            title('Handling Classes'),
            value(
                staff.handClass == null || staff.handClass!.isEmpty
                    ? 'none!'
                    : staff.handClass!,
                Icons.class_),
            title('Handling Sections'),
            value(
                staff.handSec == null || staff.handSec!.isEmpty
                    ? 'none!'
                    : staff.handSec!,
                TablerIcons.section),
            title('No of Class/Sec Handled'),
            value(
                staff.handNoCs == null || staff.handNoCs!.isEmpty
                    ? 'none!'
                    : staff.handNoCs!,
                TablerIcons.hash),
            title('Annual Exam Performance (Previous Year)'),
            value('1. Class Average : ${staff.pyAvg ?? 'none!'}',
                TablerIcons.chart_bar),
            value('2. Class Highest : ${staff.pyHigh ?? 'none!'}',
                TablerIcons.chart_bar),
            value('3. Class Lowest : ${staff.pylow ?? 'none!'}',
                TablerIcons.chart_bar),
            value('4. Class Percentage : ${staff.pyPer ?? 'none!'}',
                TablerIcons.chart_bar),
            title('No. of Centums Produced in Classes X & XII Board Exams'),
            value(staff.centums ?? 'none!', TablerIcons.progress_check),
            title(
                'Status- Worked as observer /H.E /A.H.E/ Sub Examiner (Cls X & XII Teachers)'),
            value(staff.statusObserver ?? 'none!', TablerIcons.status_change),
            title('Additional Duties & Responsibilities Performed'),
            value(staff.responsibilities ?? 'none!', TablerIcons.list_details),
            title('Special Talent (If Any)'),
            value(staff.talent ?? 'none!', TablerIcons.certificate_2),
            title('No of Workshops Attended & Details of the Workshops'),
            value(staff.workshops ?? 'none!', TablerIcons.certificate),
            title('Promotion Eligibility Test Marks (If Any)'),
            value('${staff.testmark ?? 'none!'}', TablerIcons.star),
            title('Status Cleared TET/NET/SET Exam'),
            value(staff.etExam ?? 'none!', TablerIcons.file_text),
            title('SCT Marks - SCT 1'),
            value(staff.sct1 ?? 'none!', TablerIcons.scoreboard),
            title('SCT Marks - SCT 2'),
            value(staff.sct2 ?? 'none!', TablerIcons.scoreboard),
            title('Teacher\'s Attendance % (Previous Year)'),
            value(staff.att ?? 'none!', TablerIcons.checklist),
            title('Student\'s Feedback Score 1'),
            value('Feedback 1 : ${staff.feed1 ?? 'none!'}', Icons.feedback),
            value('Feedback 2 : ${staff.feed2 ?? 'none!'}', Icons.feedback),
            value('Feedback 3 : ${staff.feed3 ?? 'none!'}', Icons.feedback),
            title('Staff Appraisal Score (%)'),
            value(staff.appraisal ?? 'none!', TablerIcons.checklist),
            if (file.isNotEmpty) title('Downloaded Info'),
            SizedBox(height: 10),
            if (file.isNotEmpty) SavedPdf(file: file),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
