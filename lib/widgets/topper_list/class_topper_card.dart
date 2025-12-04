import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/controller/topper_list_controller.dart';
import 'package:senthil/model/topper_list_model.dart';
import 'package:senthil/view/pdf_viewer_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ClassTopperCard extends StatelessWidget {
  const ClassTopperCard({super.key, required this.snap, required this.isDark});
  final TopperListModel snap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Builder(builder: (context) {
      int len = snap.data.schools.length;
      return DefaultTabController(
        length: len,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  isScrollable: len > 4 ? true : false,
                  tabAlignment: len > 4 ? TabAlignment.start : null,
                  labelStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  labelColor: AppController.headColor,
                  indicatorColor: AppController.darkGreen,
                  dividerColor: Colors.grey.withAlpha(30),
                  tabs: [
                    for (var school in snap.data.schools) Tab(text: school)
                  ],
                ),
                SizedBox(
                  height: size.height * 0.65,
                  child: TabBarView(children: [
                    for (var school in snap.data.schools)
                      _buildSchoolToppers(school, context),
                  ]),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget myRow(SubjectMark item, int index) => Builder(builder: (context) {
        String link = item.file ?? '';
        TextStyle style1 = TextStyle(
            color: link.isEmpty
                ? null
                : isDark
                    ? AppController.lightBlue
                    : baseColor);
        return InkWell(
          onTap: () async {
            if (link.isNotEmpty) {
              if (kIsWeb) {
                final url = '${AppController.basefileUrl}/$link';
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url);
                }
              } else {
                Get.to(() => PdfViewerScreen(fileName: link),
                    transition: Transition.zoom);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppController.darkGreen,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 8),
                Text(item.subject, style: style1),
                SizedBox(width: 8),
                Spacer(),
                Text(item.mark.toString(), style: style1)
              ],
            ),
          ),
        );
      });

  Widget _buildSchoolToppers(String school, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final schoolToppers = snap.data.classToppers[school] ?? [];
    Map<int, List<ClassTopperStudent>> rankedStudents = {};

    if (schoolToppers.isEmpty) {
      return Center(
        child: Text(
          'No toppers found',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }
    for (int i = 0; i < schoolToppers.length && i < 3; i++) {
      int rank = i + 1;
      rankedStudents[rank] = [schoolToppers[i]];
    }

    return ListView(
      shrinkWrap: true,
      children: [
        Wrap(
          spacing: 5,
          children: rankedStudents.entries.map((entry) {
            int rank = entry.key;
            List<ClassTopperStudent> students = entry.value;

            return SizedBox(
              width: size.width > 900 ? (size.width / 3) - 20 : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: baseColor.withAlpha(50)),
                    child: Text(
                      'Rank $rank',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  for (var student in students)
                    _buildStudentCard(student, context,
                        student == students[0] && size.width > 500),
                ],
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buildStudentCard(
      ClassTopperStudent student, BuildContext context, bool isFirst) {
    String image = student.photo?.isEmpty ?? true
        ? '${AppController.baseImageUrl}/placeholder.jpg'
        : '${AppController.basefileUrl}/${student.photo}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: ExpansionTileItem.outlined(
        initiallyExpanded: isFirst,
        title: Text(student.student ?? 'Unknown Student'),
        leading: GestureDetector(
          onTap: () => TopperListController.openImage(
              context, image, student.student ?? 'Student'),
          child: CircleAvatar(
            backgroundColor: baseColor.withAlpha(150),
            backgroundImage: NetworkImage(image),
          ),
        ),
        children: [
          for (var i = 0; i < student.subjects.length; i++)
            myRow(student.subjects[i], i),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppController.red)),
            child: Text(
              'Total: ${student.total} / ${student.maxTotal}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppController.red),
            ),
          )
        ],
      ),
    );
  }
}
