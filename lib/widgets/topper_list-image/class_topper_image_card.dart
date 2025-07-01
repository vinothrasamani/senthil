import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senthil/controller/app_controller.dart';
import 'package:senthil/controller/theme_controller.dart';
import 'package:senthil/controller/topper_list_controller.dart';
import 'package:senthil/model/topper_list_image_model.dart';
import 'package:senthil/view/pdf_viewer_screen.dart';

class ClassTopperImageCard extends StatelessWidget {
  const ClassTopperImageCard(
      {super.key, required this.snap, required this.isDark});
  final TopperListImageModel snap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget myRow(TopperListImageListElement item, int index) =>
        Builder(builder: (context) {
          String link = item.filename;
          TextStyle style1 = TextStyle(
              color: link.isEmpty
                  ? null
                  : isDark
                      ? AppController.lightBlue
                      : baseColor);
          return InkWell(
            onTap: () {
              if (link.isNotEmpty) {
                Get.to(() => PdfViewerScreen(fileName: link),
                    transition: Transition.zoom);
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
                  Text(item.subjectName, style: style1),
                  SizedBox(width: 8),
                  Spacer(),
                  Text(item.value.toStringAsFixed(1), style: style1)
                ],
              ),
            ),
          );
        });

    List<Widget> tiles(TopperDatum data) => [
          for (var details in data.details)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: ExpansionTileItem.outlined(
                title: Text(details.stud.studentName),
                leading: Builder(builder: (context) {
                  String image = details.stud.photo.isEmpty
                      ? '${AppController.baseImageUrl}/placeholder.jpg'
                      : '${AppController.basefileUrl}/${details.stud.photo}';
                  return GestureDetector(
                    onTap: () => TopperListController.openImage(
                        context, image, details.stud.studentName),
                    child: CircleAvatar(
                      backgroundColor: baseColor.withAlpha(150),
                      backgroundImage: NetworkImage(image),
                    ),
                  );
                }),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(TablerIcons.id, size: 14),
                    SizedBox(width: 5),
                    Text(
                      details.stud.adminno,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                children: [
                  for (var item in details.info)
                    myRow(item, details.info.indexOf(item)),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppController.red)),
                    child: Text(
                      details.stud.subjectTeacher.isEmpty
                          ? '(Total : None)'
                          : details.stud.subjectTeacher,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppController.red),
                    ),
                  )
                ],
              ),
            ),
        ];

    List<Widget> wrapChildren(TopperListImageClsTopper topper) => [
          for (var data in topper.topperData)
            SizedBox(
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
                        color: baseColor.withAlpha(isDark ? 100 : 50)),
                    child: Text(
                      'Rank ${data.rank}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...tiles(data),
                ],
              ),
            )
        ];

    return Builder(builder: (context) {
      int len = snap.data.clsToppers.length;
      return DefaultTabController(
        length: len,
        child: Card(
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
                    for (var topper in snap.data.clsToppers)
                      Tab(text: topper.school)
                  ],
                ),
                SizedBox(
                  height: size.height * 0.7,
                  child: TabBarView(children: [
                    for (var topper in snap.data.clsToppers)
                      ListView(
                        children: [
                          Wrap(
                            spacing: 5,
                            children: wrapChildren(topper),
                          )
                        ],
                      ),
                  ]),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
